###############################################################################
##PARDatabase.py
##Author: J. Timothy Balint
##
##Performs all database calls with respect to the PAR format
###############################################################################

import MySQLdb

##This function transforms a word into something that is parseable by wordnet
#@param obj A string containing the word to be broken up
#@returns a string of form this_is_an_example
def transformToWordNetFormat(obj):
    #We first see if the string is space delimeted
    obj = obj.strip()
    new_obj=obj.split(" ")
    if len(new_obj) == 1:
        new_obj=re.findall("[A-Z][^A-Z]*",obj)
        if len(new_obj) == 0:
            new_obj = obj.split(" ")
    return '_'.join([i.lower() for i in new_obj])

##Creates the action table for par. Also drops the current table
action_string="""
                DROP TABLE IF EXISTS action;
                CREATE TABLE action(
                act_id INT(9) PRIMARY KEY,
                act_name VARCHAR(40)  NOT NULL DEFAULT '',
                act_appl_cond VARCHAR(40) NULL,
                act_prep_spec VARCHAR(40) NULL,
                act_exec_steps VARCHAR(40) NULL,
                act_term_cond VARCHAR(40) NULL,
                act_during_assert VARCHAR(40) NULL,
                act_post_asser VARCHAR(40) NULL,
                act_purpose_achieve VARCHAR(60) NULL,
                act_dur_time_id INT(9) DEFAULT -1,
                act_obj_num INT(9) DEFAULT -1,
                act_site_type_id INT(9) DEFAULT -1,
                wordnet_sense TINYINT(4) DEFAULT -1
                );\n"""

object_string="""
              DROP TABLE IF EXISTS object;
              CREATE TABLE object(
              obj_id INT(9) PRIMARY KEY,
              obj_name VARCHAR(40) NOT NULL DEFAULT '',
              is_agent TINYINT(1) DEFAULT 0,
              parent_id INT(9) DEFAULT -1,
              wordnet_sense TINYINT(4) DEFAULT -1
              );\n"""

affordance_string="""
                 DROP TABLE IF EXISTS obj_capable;
                 CREATE TABLE obj_capable(
                 obj_id INT(9),
                 act_id INT(9),
                 act_pos TINYINT(4),
                 PRIMARY KEY(obj_id,act_id,act_pos),
                 FOREIGN KEY obj_id REFERENCES object(obj_id),
                 FOREIGN KEY act_id REFERENCES action(act_id)
                  );\n"""

parent_string = """
                DROP TABLE IF EXISTS action_parent;
                CREATE TABLE action_parent(
                act_id INT(9),
                parent_id INT(9),
                PRIMARY KEY(act_id,parent_id)
                );\n"""

class PARConnection:

    ##Initalizes the database connection (saves the connection to the object)
    #@param host The host machines address
    #@param user The user name of the connectionn
    #@param password The pass word of the connection
    #@param databse The name of the database. Defaults to pardb
    def __init__(self,host,user,password,database="pardb"):
        self.conn=MySQLdb.connect(host,user,passwd=password,db=database,port=3306)
        self.command_string=""

    ##Returns the current command string
    def __str__(self):
        return self.command_string

    ##Commits the current command string to the database
    #@returns True if commit is successful, False otherwise
    def commit(self):
        success=False
        try:
            cur=self.conn.cursor()
            success=cur.execute(self.command_string)
            cur.close()
        except:
            pass
        return success
    
    ##Searches the database to get the id of the object in question. If there are multiples, it find the most general
    #@param obj The name of the object to find
    #@returns The id of the object, or -1 if not found
    def getObjectID(self,obj):
        obj_id=-1;
        try:
            cur=self.conn.cursor()
            find_string="SELECT obj_id from object WHERE obj_name LIKE '"+transformToPARFormat(obj)+"' ORDER BY obj_id"
            cur.execute(find_string)
            row=cur.fetchone()
            if row is not None:
                obj_id=row[0]
            cur.close()
        except:
            pass#No need to prepare passed this point
        return obj_id

    ##Searches the database to get the id of the object in question. It uses a partial name search (%%) to find the object
    #@param obj The name of the object to find
    #@returns The id of the object, or -1 if not found
    def getObjectIDByPartialName(self,obj):
        obj_id=-1;
        try:
            cur=self.conn.cursor()
            find_string="SELECT obj_id from object WHERE obj_name LIKE '%"+transformToPARFormat(obj)+"%' ORDER BY obj_id"
            cur.execute(find_string)
            row=cur.fetchone()
            if row is not None:
                obj_id=row[0]
            cur.close()
        except:
            pass#No need to prepare passed this point
        return obj_id

    ##Searches the database to get the name of an object in question
    #@param obj The id of the object to find
    #@returns the name of the object, or None if the object does not exist
    def getObjectName(self,obj):
        obj_name=None
        try:
            cur=self.conn.cursor()
            find_string="SELECT obj_name from object WHERE obj_id = "+str(obj);
            cur.execute(find_string)
            row=cur.fetchone()
            if row is not None:
                obj_name=row[0]
            cur.close()
        except:
            pass
        return obj_name

    def getAllObjectNames(self):
        obj_names=[]
        try:
            cur=self.conn.cursor()
            find_string="SELECT obj_name from object WHERE 1";
            cur.execute(find_string)
            for row in cur:
                obj_names.append(row[0])
            cur.close()
        except:
            pass
        return obj_names
        
    ##Searches the database to get the object's wordnet sense
    #@param act_id The id of the object
    #@returns The sense number, or -1 if the action does not exist
    def getObjectSense(self,obj_id):
        sense=-1
        try:
            cur=self.conn.cursor()
            find_string="SELECT wordnet_sense from object where obj_id = "+str(obj_id)
            cur.execute(find_string)
            row=cur.fetchone()
            if row is not None:
                sense=row[0]
            cur.close()
        except:
            pass
        return sense

    ##Searches the database to get an action's name from its id.
    #@param act_id the action's id
    #@returns The name of the action if one exists, or None otherwise
    def getActionName(self,act_id):
        act_name=None
        try:
            cur=self.conn.cursor()
            find_string="SELECT act_name from action WHERE act_id = "+str(obj);
            cur.execute(find_string)
            row=cur.fetchone()
            if row is not None:
                act_name=row[0]
            cur.close()
        except:
            pass
        return act_name


    def getAllActionNames(self):
        act_names=[]
        try:
            cur=self.conn.cursor()
            find_string="SELECT act_name from action WHERE 1";
            cur.execute(find_string)
            for row in cur:
                act_names.append(row[0])
            cur.close()
        except:
            pass
        return act_names

    ##Searches the database to get the action's id from it's name
    #@param act_name The action's name
    #@returns The id of the action, or -1 if not found
    def getActionID(self,act_name):
        act_id=-1;
        try:
            cur=self.conn.cursor()
            find_string="SELECT act_id from action WHERE act_name LIKE '"+transformToPARFormat(act_name)+"' ORDER BY act_id"
            cur.execute(find_string)
            row=cur.fetchone()
            if row is not None:
                act_id=row[0]
            cur.close()
        except:
            pass#No need to prepare passed this point
        return act_id
    
    ##Searches the database to get the action's wordnet sense
    #@param act_id The action of the id
    #@returns The sense number, or -1 if the action does not exist
    def getActionSense(self,act_id):
        sense=-1
        try:
            cur=self.conn.cursor()
            find_string="SELECT wordnet_sense from action where act_id = "+str(act_id)
            cur.execute(find_string)
            row=cur.fetchone()
            if row is not None:
                sense=row[0]
            cur.close()
        except:
            pass
        return sense
        
    ##CREATES A MYSQL action string
    #@param act_id The id of the action. This must be unique
    #@param act_name The name of the action
    #@param parent The parent's action id
    #@param sense the wordnet sense of the action
    #@param overwrite If set to True, overwrites the current string with a new set of actions
    def addAction(self,act_id,act_name,parent = None,sense = -1,overwrite=False):
        act_string="INSERT INTO action(act_id,act_name,wordnet_sense) VALUES ("
        act_string+=','.join([str(act_id),"'"+transformToPARFormat(str(act_name))+"'",str(sense)])+");\n"
        if parent is not None:
            par_string = "INSERT INTO action_parent VALUE(" +','.join([str(act_id),str(parent)]) + ");\n"
        else:
            par_string = "";
        if overwrite:
            self.command_string=action_string+act_string+parent_string+par_string
        else:
            self.command_string+=act_string + par_string

    ##CREATES A MYSQL action parent string. Useful when there are multiple parents
    #@param act_id The id of the action
    #@param parnet the parent's action id
    #@param overwrite If set to True, overwrites the current string with a new set of actions
    def addParent(self,act_id,parent,overwrite = False):
        par_string = "INSERT INTO action_parent VALUE(" +','.join([str(act_id),str(parent)]) + ");\n"
        if overwrite:
            self.command_string=parent_string+par_string
        else:
            self.command_string+=par_string
        

    ##CREATES A MYSQL object string
    #@param obj_id The id of the object. This must be unique
    #@param obj_name The name of the object
    #@param parent The parent's object id
    #@param sense the wordnet sense of the action
    #@param overwrite If set to True, overwrites the current string with a new set of actions
    def addObject(self,obj_id,obj_name,parent,sense,overwrite=False):
        obj_string="INSERT INTO object(obj_id,obj_name,parent_id,wordnet_sense) VALUES ("
        obj_string+=','.join([str(obj_id),"'"+transformToPARFormat(str(obj_name))+"'",str(parent),str(sense)])+");\n"
        if overwrite:
            self.command_string=object_string+obj_string
        else:
            self.command_string+=obj_string

    ##CREATES a connection between an action and an object
    #@param obj_id The id of the object. Must already exist in the database
    #@param act_id The id of the action. Must already exist in the database
    #@param arg_id The position of the action's argument.
    #@param overwrite If set to True, overwrites the current string with a new set of actions
    def addConnection(self,obj_id,act_id,arg_id,overwrite=False):
        con_string="INSERT INTO obj_capable VALUES("+",".join([obj_id,act_id,arg_id])+");"
        if overwrite:
            self.command_string=affordance_string+con_string
        else:
            self.command_string+=con_string

    ##Gets all connection between an action and any given object
    def getAllConnections(self,act_id):
        result = [];
        try:
            cur=self.conn.cursor()
            find_string="SELECT obj_num,obj_id from obj_act WHERE act_id = "+str(act_id)+"ORDER BY obj_num, obj_id"
            cur.execute(find_string)
            for row in cur:
                result.append((row[0],row[1]))
            cur.close()
        except:
            pass#No need to prepare passed this point
        return result
            
    ##Updates a PAR action field with a new value. Generally used for updating python script connections
    #@param act_id The id of the action. Must already exist in the database
    #@param field The field hat needs to be changed 
    #@param val The new value of the field
    def updateActionField(self,act_id,field,val):
        self.command_string+="UPDATE action SET "+str(field)+"="+str(val)+" WHERE act_id ="+str(act_id)+";\n"


class PARManager:#Was also called PAR Connection

    ##Initalizes the database connection (saves the connection to the object)
    #@param host The host machines address
    #@param user The user name of the connectionn
    #@param password The pass word of the connection
    #@param databse The name of the database. Defaults to pardb
    def __init__(self,host,user,password,database="parmanager"):
        self.conn=MySQLdb.connect(host,user,passwd=password,db=database,port=3306)
        self.command_string=""

    ##Returns the current command string
    def __str__(self):
        return self.command_string

    def getObjects(self):
        objs = []
        try:
            cur=self.conn.cursor()
            find_string="SELECT obj_id,obj_name from object WHERE 1 ORDER BY obj_id"
            cur.execute(find_string)
            for row in cur:
                objs.append((row[0],row[1]))
                
        except:
            pass
        return objs
    
    def getObjectName(self,obj_id):
        name = "None"
        try:
            cur=self.conn.cursor()
            find_string="SELECT obj_name from object WHERE obj_id = "+str(obj_id)+" ORDER BY obj_id"
            cur.execute(find_string)
            row = cur.fetchone()
            if row is not None:
                name = row[0]
        except:
            pass
        return name

    def getActions(self):
        objs = []
        try:
            cur=self.conn.cursor()
            find_string="SELECT act_id,act_name from action WHERE 1 ORDER BY act_id"
            cur.execute(find_string)
            for row in cur:
                objs.append((row[0],row[1]))
                
        except:
            pass
        return objs
    
    def callActions(self, act_id):
        condList=[]
        asserList=[]
        cur=self.conn.cursor()
        cond="SELECT predicate, arg1, arg2, argres from conditions where act_id = " + str(act_id)
        cur.execute(cond)
        for row in cur:
            row=list(row)
            if row[0] == "getProperty":
                row[0] = "Property"
            if row[1] == None:
                row[1]= 'null'
            if row[2] == None:
                row[2] = 'null'
            if row[3] == None:
                row[3] = 'null'
            print row
            condList.append(row)
        print condList
        for row in condList:
            asser="SELECT act_id from assertions where predicate ='" + '%' + str(row[0]) + "' and " + " arg1 = '" + str(row[1]) + "' and " + " arg2 = "+ str(row[2]) +" and "+ "argres = " +str(row[3]) +""
            print asser
        cur.execute(asser)
        for row in cur:
            asserList.append(row[0])
        print asserList
        return asserList
        
    def getActionsWithTasks(self):
        objs = []
        try:
            cur=self.conn.cursor()
            find_string="SELECT act_id,act_name from action JOIN task ON (action.act_id = task.action_id) WHERE 1 ORDER BY act_id"
            cur.execute(find_string)
            for row in cur:
                objs.append((row[0],row[1]))
                
        except:
            pass
        return objs

    def getActionsWithoutTasks(self):
        objs = []
        try:
            cur=self.conn.cursor()
            find_string="SELECT act_id,act_name from action WHERE act_id not in (SELECT action_id from task) ORDER BY act_id"
            cur.execute(find_string)
            for row in cur:
                objs.append((row[0],row[1]))
                
        except:
            pass
        return objs

    def getConditionsAndAssertions(self,act_id):
        once = {}
        every = {}
        try:
            cur = self.conn.cursor()
            find_string = "SELECT cond_id,is_every,retval from cond_assert WHERE act_id = "+str(act_id)+" ORDER BY cond_id"
            cur.execute(find_string)
            ca = []
            for row in cur:
                ca.append((row[0],row[1],row[2]))
            for c in ca:
                cond = ""
                find_string = "SELECT predicate,arg1,arg2,argres FROM conditions WHERE act_id = "+str(act_id)+ " AND cond_id = "+str(c[0])+" ORDER BY cond_pos"
                cur.execute(find_string)
                fin = len([row for row in cur])
                counter = 0
                for row in cur:
                    if row[3] is None:
                        if row[2] is not None:
                            cond +=row[0]+"("+row[1]+","+row[2]+")"
                        else:
                            cond +=row[0]+"("+row[1]+")"
                    elif row[3] == "True":
                        if row[2] is not None:
                            cond +=row[0]+"("+row[1]+","+row[2]+")"
                        else:
                            cond +=row[0]+"("+row[1]+")"
                    elif row[3] == "False":
                        if row[2] is not None:
                            cond +="not "+row[0]+"("+row[1]+","+row[2]+")"
                        else:
                            cond +="not "+row[0]+"("+row[1]+")"
                    else:
                        if row[2] is not None:
                            cond +=row[0]+"("+row[1]+","+row[2]+") = "+row[3]
                        else:
                            cond +=row[0]+"("+row[1]+") = "+row[3]
                    if counter != fin -1:
                        cond +=" AND "
                    counter +=1
                find_string = "SELECT predicate,arg1,arg2,argres FROM assertions WHERE act_id = "+str(act_id)+ " AND cond_id = "+str(c[0])+" ORDER BY cond_pos"
                cur.execute(find_string)
                assertion = ""
                for row in cur:
                    if row[3] is None or row[3] == "True":
                        if row[2] is not None:
                            assertion +=row[0]+"("+row[1]+","+row[2]+")"
                        else:
                            assertion +=row[0]+"("+row[1]+")"
                    elif row[3] == "False":
                        if row[2] is not None:
                            assertion +="not "+row[0]+"("+row[1]+","+row[2]+")"
                        else:
                            assertion +="not "+row[0]+"("+row[1]+")"
                    else:
                        if row[2] is not None:
                            assertion +=row[0]+"("+row[1]+","+row[2]+") = "+row[3]
                        else:
                            assertion +=row[0]+"("+row[1]+") = "+row[3]
                    assertion += " AND "

                if c[2] == 1:
                    assertion += "SUCCESS"
                else:
                    assertion += "FAILURE"
                if c[1] == 0:
                    once[cond] = assertion
                else:
                    every[cond] = assertion
        except:
           pass
        return (once,every)
    
    def getActionName(self,act_id):
        name = ""
        try:
            cur=self.conn.cursor()
            find_string="SELECT act_name from action WHERE act_id = "+str(act_id)+" ORDER BY act_id"
            cur.execute(find_string)
            row = cur.fetchone()
            if row is not None:
                name = row[0]
        except:
            pass
        return name

    def getActParent(self,act_id):
        name = "None"
        try:
            cur=self.conn.cursor()
            find_string="SELECT act_id, act_name from action WHERE act_id = (SELECT parent_id from openpardb.action_parent WHERE act_id ="+str(act_id)+") ORDER BY act_id"
            cur.execute(find_string)
            row = cur.fetchone()
            if row is not None:
                name = (row[0],row[1])
        except:
            pass
        return name
    
    def getActParentName(self,act_id):
        name = "None"
        try:
            cur=self.conn.cursor()
            find_string="SELECT act_name from action WHERE act_id = (SELECT parent_id from openpardb.action_parent WHERE act_id ="+str(act_id)+") ORDER BY act_id"
            cur.execute(find_string)
            row = cur.fetchone()
            if row is not None:
                name = row[0]
        except:
            pass
        return name

    def getActParentSense(self,act_id):
        name = "None"
        try:
            cur=self.conn.cursor()
            find_string="SELECT wordnet_sense from action WHERE act_id = (SELECT parent_id from openpardb.action_parent WHERE act_id ="+str(act_id)+") ORDER BY act_id"
            cur.execute(find_string)
            row = cur.fetchone()
            if row is not None:
                name = row[0]
        except:
            pass
        return name
    
    def getParentName(self,obj_id):
        name = "None"
        try:
            cur=self.conn.cursor()
            find_string="SELECT obj_name from object WHERE obj_id = (SELECT parent_id from object WHERE obj_id ="+str(obj_id)+") ORDER BY obj_id"
            cur.execute(find_string)
            row = cur.fetchone()
            if row is not None:
                name = row[0]
        except:
            pass
        return name

    def getSemantics(self,obj_id):
        semantics = {}
        try:
            cur=self.conn.cursor()
            find_string="SELECT DISTINCT table_name from openpardb.obj_prop where obj_id ="+str(obj_id)
            cur.execute(find_string)
            for row in cur:
                semantics[row[0]] = []
            for table_name in semantics:
                #cur.clear()
                find_string = "SELECT name_value from openpardb.obj_prop INNER JOIN openpardb."+table_name+" ON (prop_value=id_value) WHERE obj_id = "+str(obj_id)+" and table_name = '"+table_name+"'"
                #print find_string
                cur.execute(find_string)
                for row in cur:
                    semantics[table_name].append(str(row[0]))
                
        except:
            pass
        return dictionaryLatexFormat(semantics)

    def getRoles(self,act_id):
        roles = {}
        try:
            cur=self.conn.cursor()
            find_string = "SELECT obj_num,obj_name FROM obj_act NATURAL JOIN object WHERE act_id = "+str(act_id)+" ORDER BY obj_num"
            cur.execute(find_string)
            for row in cur:
                roles[row[0]] = row[1]
        except:
            pass
        return roles

    def getAssertions(self,act_id):
        assertions = []
        try:
            cur=self.conn.cursor()
            find_string = "SELECT predicate,arg1,arg2,argres FROM assertions WHERE act_id = "+str(act_id)
            cur.execute(find_string)
            for row in cur:
                assertion = ""
                if row[3] is None or row[3] == "True":
                    if row[2] is not None:
                            assertion +=row[0]+"("+row[1]+","+row[2]+")"
                    else:
                            assertion +=row[0]+"("+row[1]+")"
                elif row[3] == "False":
                    if row[2] is not None:
                            assertion +="not "+row[0]+"("+row[1]+","+row[2]+")"
                    else:
                            assertion +="not "+row[0]+"("+row[1]+")"
                else:
                    if row[2] is not None:
                            assertion +=row[0]+"("+row[1]+","+row[2]+") = "+row[3]
                    else:
                            assertion +=row[0]+"("+row[1]+") = "+row[3]
                assertions.append(assertion)
        except:
            pass
        return assertions
    
    def getAllActionRoles(self):
        roles = []
        try:
            cur = self.conn.cursor()
            find_string = "SELECT distinct act_id from obj_act where 1";
            cur.execute(find_string)
            for row in cur:
                roles.append(row[0])
        except:
            pass
        return roles

    def getTask(self,act_id):
        task_list = []
        changes = {"a":"And","j":"Join"}
        if True:#try:
            cur=self.conn.cursor()
            find_string="SELECT task_string from task where action_id ="+str(act_id)+" AND exec_steps = 1"
            cur.execute(find_string)
            row = cur.fetchone()
            if row is not None:
                string = row[0]
                stack = []
                counter = 0
                #print string
                for item in string:
                    if item == 'p':
                        find_string = "SELECT act_name FROM action WHERE act_id = (SELECT task_id from parmanager.task_actions WHERE action_id = "+str(act_id)+" and task_position = "+str(counter)+")"
                        counter +=1
                        cur.execute(find_string)
                        row = cur.fetchone()
                        #print str(counter - 1),row[0]
                        stack.append(latexFormat(row[0]))
                    elif item.isdigit():
                        num = int(item)
                        group = []
                        for i in range(num+1):
                            group.append(stack.pop())
                        conn = group[0]
                        group = group[1:]
                        group.reverse()
                        group_string = str(conn)+"("+",".join(group)+") "
                        stack.append(group_string)
                    else:
                        stack.append(changes[item])
                task_list = stack
        #except:         
        #    pass
        return task_list

    ##Searches the database to get the action's wordnet sense
    #@param act_id The action of the id
    #@returns The sense number, or -1 if the action does not exist
    def getActionSense(self,act_id):
        sense=-1
        try:
            cur=self.conn.cursor()
            find_string="SELECT wordnet_sense from action where act_id = "+str(act_id)
            cur.execute(find_string)
            row=cur.fetchone()
            if row is not None:
                sense=row[0]
            cur.close()
        except:
            pass
        return sense
