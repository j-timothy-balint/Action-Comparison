from OntologyGeneration import SemanticGeneration
from OntologyGeneration.DataStructures import WordNetNode,treePropertyCleanUp
from nltk.corpus import wordnet as wn
import PARDatabase
from OntologyGeneration import HierarchyGeneration,CommonFunctions
import csv
from sklearn.decomposition import PCA

db=PARDatabase.PARManager('localhost','root','root','parmanager')
sem=SemanticGeneration.FrameOntology(None)

def cleanUp(data):
    pca = PCA(2)
    return pca.fit_transform(data)

def buildWVTree():
    import gensim
    from sklearn.cluster import DBSCAN
    res = HierarchyGeneration.SynsetResolver(None,method = "word-vector", hand_cluster = False,multi_parent = True)
    nodes = {}
    forest = {}
    seen_words = {}
    tasks = db.getActionsWithTasks()
    for t in tasks:
        names = HierarchyGeneration.generateWordAsSysnet(CommonFunctions.transformToWordNetFormat(t[1]))
        if isinstance(names,list):
            checked = []
            for n in names:
                if str(n) in seen_words:
                    checked.append(seen_words[str(n)])
                else:
                    seen_words[str(n)] = n
                    checked.append(n)
            names = checked
        nodes[t[1]]=names
        #if isinstance(names,list):
        #    for n in names:
        #        n.setNumber(t[0])
        #else:
        #    names.setNumber(t[0])
    res.setAnswers(nodes)
    model = gensim.models.Word2Vec.load('Testing data/Skipgrams and BOW/Wiki-5BOW')
    clusters = [DBSCAN(2,min_samples=2),DBSCAN(3.5,min_samples=2),DBSCAN(5,min_samples=2)]
    forest = res.buildForestWordVectors(model,clusters,decomposition=cleanUp)
    #At this point, the answers we want to represent in nodes is the WNN that were just created from forest
    queue = [i for i in forest]
    seen = []
    test_nodes = [n.lower() for n in nodes]
    while len(queue) > 0:
        item = queue.pop(0)
        if item not in seen:
            if str(item).lower() in test_nodes:
                #Here, we have a match, we need to match it to tasks
                found = [t for t in tasks if t[1].lower() == str(item).lower()]
                if len(found) == 1:
                    item.setNumber(found[0][0])
                    nodes[str(item)] = item
            seen.append(item)
            if item.getChildren() is not None:
                #print str(item.getSynSet()),"children are",str([str(i.getSynSet()) for i in item.getChildren()])
                queue.extend([i for i in item.getChildren() if i not in seen])

    #printBFS(forest)
    return (nodes,forest)

def printBFS(forest):
    queue = [i for i in forest]
    seen = []
    while len(queue) > 0:
        item = queue.pop(0)
        if item not in seen:
            seen.append(item)
            print str(item.getSynSet()),
            if item.getParent() is not None:
                if isinstance(item.getParent(),list):
                    print ",".join([str(i) for i in item.getParent()])
                else:
                    print str(item.getParent().getSynSet())
            else:
                print ""
            if item.getChildren() is not None:
                #print str(item.getSynSet()),"children are",str([str(i.getSynSet()) for i in item.getChildren()])
                queue.extend([i for i in item.getChildren() if i not in seen])


def parseAction():
        #Gets a frame from the set of actions
        nodes = {}
        tasks = db.getActionsWithTasks()
        for t in tasks:
            sense = db.getActionSense(t[0])
            if sense == -1:
                ps = db.getActParentSense(t[0])
                parent_name = db.getActParentName(t[0])
                nodes[t[1]]=WordNetNode(wn.synset(parent_name+'.v.'+str(ps)))
                nodes[t[1]].setNumber(t[0])
                #parent is garenteed to have it
                
                #nodes[t[1]] = WordNetNode(t[1]) #For no forest whatsoever
                #nodes[t[1]].setNumber(t[0])
            else:
                nodes[t[1]]=WordNetNode(wn.synset(t[1]+".v."+str(sense)))
                nodes[t[1]].setNumber(t[0])
        return nodes


def parseTree():
    #Parses the entire tree from the database
    roots = []
    nums = {}
    nodes = {}
    att_parent = {}
    #We are only doing parse trees for hand done, which this week is only
    #single parent, so this will be a little sloppy
    acts = db.getActions()
    tasks = [i[0] for i in db.getActionsWithTasks()] 
    for act in acts:
        wnn = WordNetNode(act[1])
        wnn.setNumber(act[0])
        nums[act[0]]=wnn
        if act[0] in tasks: #So the task stuff works
            nodes[act[1]] = wnn
        parent = db.getActParent(act[0])
        if isinstance(parent,tuple):
            if parent[0] in nums:
                parent = nums[parent[0]]
                parent.attachChild(wnn)
            else:
                att_parent[wnn] = parent[0]
        else:
            roots.append(wnn)
    for wnn in att_parent:
        parent = nums[att_parent[wnn]]
        parent.attachChild(wnn)
    return (nodes,roots)
                    

def getProperties(actions):
    #Here, we get the roles and assertions or conditions from the database, and set it up like ALET
    for action in actions:
        act = actions[action]
        if act is not False and act is not None:
            if isinstance(act,list):
                for a in act:
                    roles = db.getRoles(a.getNumber())
                    roles = [roles[i]+str(i) for i in roles]
                    #asserts = db.getAssertions(a.getNumber())
                    (once,every) = db.getConditionsAndAssertions(a.getNumber())
                    asserts = [c+":"+once[c] for c in once] + [c+":"+every[c] for c in every]
                    print str(a),asserts,roles
                    a.setProperties((asserts,roles))
  
            else:
                roles = db.getRoles(act.getNumber())
                roles = [roles[i]+str(i) for i in roles]
                (once,every) = db.getConditionsAndAssertions(act.getNumber())
                asserts = [c+":"+once[c] for c in once] + [c+":"+every[c] for c in every]
                act.setProperties((asserts,roles))

def reconnect(nodes,forest):
    queue = [i for i in forest]
    seen = []
    while len(queue) > 0:
        item = queue.pop(0)
        seen.append(item)
        if item.getChildren() is not None:
            #print str(item.getSynSet()),"children are",str([str(i.getSynSet()) for i in item.getChildren()])
            queue.extend([i for i in item.getChildren() if i not in seen])
    for node in nodes: #Will have to do this for lists as well
        item = nodes[node]
        if item not in seen:
            found = False
            for i in seen:
                if node == str(i) and not found:
                    i.setNumber(item.getNumber())
                    nodes[node] = i
                    found = True

def countProperties(forest):
        props = 0
        queue = [i for i in forest]
        seen_list = []
        while len(queue) > 0:
                item = queue.pop(0)
                if item not in seen_list:
                    seen_list.append(item)
                    if len(item.getProperties()) > 0:
                            print str(item),item.getProperties()
                            props += len(item.getProperties())
                    if item.getChildren() is not None:
                        #print str(item.getSynSet()),"children are",str([str(i.getSynSet()) for i in item.getChildren()])
                        queue.extend([i for i in item.getChildren() if i not in seen_list])
        return props


def binaryCountProperties(forest):
        props = 0
        queue = [i for i in forest]
        seen_list = []
        while len(queue) > 0:
                item = queue.pop(0)
                if item not in seen_list:
                    seen_list.append(item)
                    if len(item.getProperties()) > 0:
                            #print str(item),item.getProperties()
                            props += 1
                    if item.getChildren() is not None:
                        #print str(item.getSynSet()),"children are",str([str(i.getSynSet()) for i in item.getChildren()])
                        queue.extend([i for i in item.getChildren() if i not in seen_list])
        return props


def getRolesNode(actions):
    roles = {}
    seen_list = []
    for action in actions:
        if actions[action] is not False:
            all_roles = {}
            if isinstance(actions[action],list):
                for item in actions[action]:
                    if item not in seen_list:
                        seen_list.append(item)
                        if len(item.getProperties()) > 0:
                            r = list(item.getProperties()[1])
                            item.setProperties(list(item.getProperties()[0]))
                            all_roles[item] = r
                    roles[action]=all_roles
            else:
                item = actions[action]
                if item not in seen_list:
                    seen_list.append(item)
                #print str(item),item.getProperties()
                    if len(item.getProperties()) > 0:
                        r = list(item.getProperties()[1])
                        item.setProperties(list(item.getProperties()[0]))
                        all_roles[item] = r
                    roles[action]=all_roles
    return roles
    
def getRoles(forest):
        props = {}
        queue = [i for i in forest]
        seen_list = []
        while len(queue) > 0:
                item = queue.pop(0)
                seen_list.append(item)
                if len(item.getProperties()) > 0:
                    #print str(item.getSynSet()),item.getProperties()
                    props[item] = list(item.getProperties()[1])
                    item.setProperties(list(item.getProperties()[0]))
                if item.getChildren() is not None:
                    #print str(item.getSynSet()),"children are",str([str(i.getSynSet()) for i in item.getChildren()])
                    queue.extend([i for i in item.getChildren() if i not in seen_list])
        return props


def setRolesNode(props):
    for p in props:
        for item in props[p]:
            item.setProperties(props[p][item])
                
def clearProps(forest):
        queue = [i for i in forest]
        while len(queue) > 0:
                item = queue.pop(0)
                item.setProperties([])
                if item.getChildren() is not None:
                    #print str(item.getSynSet()),"children are",str([str(i.getSynSet()) for i in item.getChildren()])
                    queue.extend(item.getChildren())



if __name__ == "__main__":
        #Switch to news
        resolver=HierarchyGeneration.SynsetResolver(multi_parent = False)
        #nodes = parseAction()
        (nodes,forest) = parseTree()
        #(nodes,forest) = buildWVTree()
        #forest = resolver.buildWordNetForest(nodes)
        #reconnect(nodes,forest)
        #forest = [nodes[n] for n in  nodes]
        #printBFS(forest)
        getProperties(nodes)
        #rectifyWNNs(nodes,forest)
        #printBFS(forest)
        role_props = getRolesNode(nodes)
        adverb_props_no_parse = str(countProperties(forest))
        apnpb = str(binaryCountProperties(forest))
        treePropertyCleanUp(forest)
        print "________"
        adverb_props = str(countProperties(forest))
        apb = str(binaryCountProperties(forest))
        ##printBFS(forest)
        clearProps(forest)
        setRolesNode(role_props)
        print "________"
        roles_no_parse = str(countProperties(forest))
        rnpb = str(binaryCountProperties(forest))
        #print "________"
        treePropertyCleanUp(forest)
        roles = str(countProperties(forest))
        rb = str(binaryCountProperties(forest))
        #clearProps(forest)
        print "R:",roles_no_parse,roles
        print "delta:",adverb_props_no_parse,adverb_props
        print "RB:",rnpb,rb
        print "DB:",apnpb,apb

                              

        
