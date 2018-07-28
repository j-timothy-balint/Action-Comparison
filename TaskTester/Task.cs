using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace TaskTester
{
    //This section is about comparing two task lists to find similarities between them
    //public delegate double Comparision(string a, string b); //Our comparision delegate
    class Task
    {
        Dictionary<string, char> connectives;
        List<string> task_string;
        int ignore_number = -1;
        string task_name;
        public Task(string t_n)
        {
            task_name = t_n;
            connectives = new Dictionary<string, char>();
            this.connectives["and"] = 'a';
            this.connectives["or"] = 'o';
            this.connectives["indy"] = 'i';
            this.connectives["join"] = 'j';
            this.connectives["while"] = 'w';
            this.connectives["collector"] = 'c';
            task_string = new List<string>();
        }
        public override string ToString()
        {
            StringBuilder build=new StringBuilder();
            foreach (string s in task_string)
            {
                build.Append(s + " ");
            }
            return build.ToString();
        }
        /**
         * Converts a flattened list to a full PDA, returning only the PDA component
         * @returns A PDA string of the actual items
         */
        public string convertToPDA()
        {
            if (this.task_string.Count() == 0)//If we have nothing, then we should return nothing
            {
                return "";
            }
            else
            {
                StringBuilder result = new StringBuilder();
                bool connect_last = false; //This makes sure we know the number of items after
                //Next, we go through the list and build our pda string
                foreach (string item in this.task_string)
                {
                    if (this.connective(item)) //If we have a connective, then we should say we do
                    {
                        result.Append(this.connectives[item]);
                        connect_last = true;
                    }
                    else//Otherwise, we have a primitive or connective number
                    {
                        if (connect_last)
                        {
                            result.Append(item);
                            connect_last = false;
                        }
                        else
                        {
                            result.Append("p");
                        }
                    }
                }
                return result.ToString();
            }
        }
        /**
         * This converts a pda string and list of actions into a flattened list
         */
        public void pdaToList(string pda, string[] action_list)
        {
            int counter = 0;
            char item;
            int tryint;
            for (int i = 0; i < pda.Count(); i++)
                {
                    item = pda[i];
                    if (item == 'p')
                    {
                        this.task_string.Add(action_list[counter]);
                        counter += 1;
                    }
                    else
                    {
                        if (int.TryParse(item.ToString(),out tryint))
                        {
                            int start = i;
                            i++;
                            while (i <pda.Count() && int.TryParse(pda[i].ToString(), out tryint) ) { i++; }
                            int end = i;
                            this.task_string.Add(pda.Substring(start, end - start));
                            i--;
                        }
                        else
                        {
                            this.task_string.Add(this.revConnectives(item));
                        }
                    }
                }
        }
        //Converts a pda to a list when I pass it an integer list of actions
        public void pdaToList(string pda, int[] action_list)
        {
            int counter = 0;
            char item;
            int tryint;
            for (int i = 0; i < pda.Count(); i++)
            {
                item = pda[i];
                if (item == 'p')
                {
                    this.task_string.Add(action_list[counter].ToString());
                    counter += 1;
                }
                else
                {
                    if (int.TryParse(item.ToString(), out tryint))
                    {
                        int start = i;
                        i++;
                        while (i < pda.Count() && int.TryParse(pda[i].ToString(), out tryint)) { i++; }
                        int end = i;
                        this.task_string.Add(pda.Substring(start, end - start));
                        i--;
                    }
                    else
                    {
                        this.task_string.Add(this.revConnectives(item));
                    }
                }
            }
        }
        private string revConnectives(char conn)
        {
            foreach(KeyValuePair<string,char> item in this.connectives){
                if (item.Value == conn)
                {
                    return item.Key;
                }
            }
            return "";
        }
        /**
         * Returns the symbols (action ids) in the flattened list to go with the pda.
         * @returns a list of strings representing the symbols
         */
        public string[] getSymbols()
        {
            List<string> result = new List<string>();
            bool connect_last = false; //This makes sure we know the number of items after
            foreach (string item in this.task_string)
            {
                if (this.connective(item))
                {
                    connect_last = true;
                }
                else
                {
                    if (connect_last)
                    {
                        connect_last = false;
                    }
                    else
                    {
                        result.Add(item);
                    }
                }
            }
            return result.ToArray();
        }
        /**
         *Determines if the task is acceptable, and can be placed in our format
         *@param task_string a list of strings in our given format
         *@returns true if the list is good and false otherwise
         */
        public bool checkTask()
        {
            Stack<string> pda = new Stack<string>(); //We are doing a special version of the push down autonmata
            //The parsing is a bottom up parsing
            int n; //Needed for tryParse
            bool connective=false;
            for (int i = 0; i <this.task_string.Count(); i++)
            {
                
                if (int.TryParse(this.task_string[i], out n))
                {
                    if (n != this.ignore_number && !connective)
                    {
                        pda.Push(this.task_string[i]);
                    }
                    if (connective)
                    {
                        connective = false;
                        string con = pda.Pop();
                        //The first number we pop off is the number that we will need to pop off
                        if (pda.Count == 0)
                        {
                            return false; //Don't try to pop if one doesn't exist
                        }
                        //int.TryParse(pda.Pop(), out n);
                        for (int j = 0; j < n; j++)
                        {
                            if (pda.Count == 0)
                            {
                                return false; //Shoud still have one to pop
                            }
                            pda.Pop();
                        }
                        pda.Push(con);
                    }
                }
                else
                {
                    connective = true;
                    pda.Push(this.task_string[i]);
                }
            }
            //In the end, we should be left with a single connective (basically our sentence)
            if (pda.Count == 1)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /**
         *This converts a treeview of the system into a flattened list of the system
         *@param root The root of the tree view
         *@returns a depth first parse of the tree
         */
        public void convertTreeToFlattenedList(TreeNode root)
        {
            this.task_string = new List<string>();
            this.depthParse(root);
        }
        /**
         *Helper function to do the depth first parsing
         *@param node The current node in the list
         *@param result The ordered result of the list
         */
        private void depthParse(TreeNode node)
        {
            //if there are children, add them to the list as well
            if (node.Nodes.Count > 0)
            {
                
                foreach (TreeNode n in node.Nodes)
                {
                    depthParse(n);
                }
            }
            //Add the current node to the list
            this.task_string.Add(node.Text); //Post traversal
            if (node.Nodes.Count > 0)
            {
                this.task_string.Add(node.Nodes.Count.ToString()); //Added for connectives
            }
        }

        /**
         *Small helper function to determine if we have a primitive or not
         */
        private bool primitive(string node, bool last_connective)
        {
            int n;
            if (int.TryParse(node, out n)) //If we have a number
            {
                if (last_connective) //and the last symbol was a connective
                {
                    return false; //Then we have a connective number
                }
                else
                {
                    return true; //otherwise we have a primitive
                }
            }
            else
            {
                return false; //This is the connective case
            }
        }
        //Short helper function to determine if we have a connective
        private bool connective(string node)
        {
            int n;
            if (int.TryParse(node, out n))
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        /**
         * Most basic equality function. 
         * @param a The first string
         * @param b The second string
         * @returns 1.0 if the two strings are equal, and 0.0 otherwise
         */ 
        private double equality(string a, string b)
        {
            if (a == b)
            {
                return 1.0;
            }
            else
            {
                return 0.0;
            }
        }
        /* Builds a recurrance plot between two flattened lists
         * @param first the first flattened list
         * @param second the second flattened list
         * @param comp The type of comparision to do between each element
         * @param self Says if the recurrence is a self recurrance, and should ignore the diagonal
         * @returns a 2-D matrix of comparision values
         */ 
        private double[,] buildRecurrance(string[] second, Comparision comp, bool self)
        {
            double[,] result = new double[this.task_string.Count(),second.Count()]; //We build an nxm array
            for (int i = 0; i < this.task_string.Count(); i++)
            {
                for (int j = 0; j < second.Count(); j++)
                {
                    if (self && i == j)//We obviously have a recurrence in self on the diagonal, which may prove problematic down the road
                    {
                        result[i, j] = 0.0;
                    }
                    else
                    {
                        result[i, j] = comp(this.task_string[i], second[j]);
                    }
                }
            }
            return result;
        }
        /* Builds a distance matrix from a function instead of converting to a simularity function
         * @param second the second flattened list
         * @param comp The type of comparision to do between each element
         * @param self Says if the recurrence is a self recurrance, and should ignore the diagonal
         * @returns a 2-D matrix of comparision values
         */
        public double[,] buildCostMatrix(string[] second, contextCompare comp, bool self)
        {
            double[,] result = new double[this.task_string.Count(), second.Count()]; //We build an nxm array
            bool f = false;
            
            for (int i = 0; i < this.task_string.Count(); i++)
            {
                if (i > 0)
                {
                    if (connectives.ContainsKey(this.task_string[i - 1]))
                    {
                        f = true;
                    }
                    else
                    {
                        f = false;
                    }
                }
                bool s = false;
                for (int j = 0; j < second.Count(); j++)
                {
                    if (self && i == j)//We obviously have a recurrence in self on the diagonal, which may prove problematic down the road
                    {
                        result[i, j] = 0.0;
                    }
                    else
                    {
                        if (j > 0)
                        {
                            if (connectives.ContainsKey(second[j - 1]))
                            {
                                s = true;
                            }
                            else
                            {
                                s = false;
                            }
                        }
                            result[i, j] = comp(this.task_string[i], second[j],f,s); 

                    }
                }
            }
            return result;
        }
        /*Converts a similarity matrix into a distance matrix. This is not done in place right now, so we can keep both
         *@param sim_matrix A similarity matrix between 0 and 1
         *@returns a distance matrix, which is 1-sim_matrix
         */ 
        private double[,] simToDist(double[,] sim_matrix)
        {
            double[,] dist_matrix = new double[sim_matrix.GetLength(0), sim_matrix.GetLength(1)]; //This way, we have the same size
            int i_end = dist_matrix.GetLength(0);
            int j_end = dist_matrix.GetLength(1);
            for (int i = 0; i < i_end; i++)
            {
                for (int j = 0; j < j_end; j++)
                {
                    dist_matrix[i, j] = 1.0 - sim_matrix[i, j];
                }
            }
            return dist_matrix;
        }
        /*This is the edit distance function
         */ 
        private double[,] warp(double[,] dist_matrix)
        {
            int i_end = dist_matrix.GetLength(0);
            int j_end = dist_matrix.GetLength(1);
            for (int i = 1; i < i_end; i++)//First row
            {
                dist_matrix[i, 0] += dist_matrix[i - 1, 0];
            }
            for (int j = 1; j < j_end; j++)//First Column
            {
                dist_matrix[0, j] += dist_matrix[0, j - 1];
            }
            for (int i = 1; i < i_end; i++) //This is for everything else
            {
                for (int j = 1; j < j_end; j++)
                {
                    dist_matrix[i, j] += Math.Min(dist_matrix[i - 1, j], Math.Min(dist_matrix[i, j - 1], dist_matrix[i - 1, j - 1]));
                }
            }
                return dist_matrix;
        }
        /*Takes a flattened-list, and removes the end of it to make it an acceptable flattened list
         *@param task The task that needs to be fixed
         *@returns a corrected task list. If the task list can't be corrected, it returns an empty list of strings
         */
        private void fixTask()
        {
            if (this.checkTask() || this.task_string.Count() == 0)
            {
                return;
            }
            this.task_string.RemoveRange(this.task_string.Count() - 1,1);
            this.fixTask();
        }
        /*Returns back a distance score between two tasks
         * @param second The task to compare
         * @param comp the Comparision to use
         * @returns a double of the total distance
         */
        public double getSimularity(Task second,Comparision comp)
        {
            double[,] recur = this.buildRecurrance(second.getTask().ToArray(), comp, false);
            recur = this.warp(this.simToDist(recur));
            return recur[this.task_string.Count()-1, second.getTask().Count()-1]; //Gets the last value
        }
        public double getCost(Task second, contextCompare comp)
        {
            double[,] recur = this.buildCostMatrix(second.getTask().ToArray(), comp, false);
            recur = this.warp(recur);//this.simToDist(recur)
            return recur[this.task_string.Count() - 1, second.getTask().Count() - 1]; //Gets the last value
        }
        /*Returns back the distance between two tasks, normalized to the length of the largest task
         * @param second The task to compare
         * @param comp the Comparision to use
         * @returns a double of the total distance
         */
        public double getSimularityMaxLength(Task second, Comparision comp)
        {
            double[,] recur = this.buildRecurrance(second.getTask().ToArray(), comp, false);
            recur = this.warp(this.simToDist(recur));
            return recur[this.task_string.Count() - 1, second.getTask().Count() - 1]/Math.Max(this.getTask().Count,second.getTask().Count); //Gets the last value
        }
        public double getCostMaxLength(Task second, contextCompare comp)
        {
            double[,] recur = this.buildCostMatrix(second.getTask().ToArray(), comp, false);
            recur = this.warp(recur);//this.simToDist(recur)
            return recur[this.task_string.Count() - 1, second.getTask().Count() - 1] / Math.Max(this.getTask().Count, second.getTask().Count); //Gets the last value
        }
        /* Finds the positions of all the subLists in the matrix
         * @param first the first string to compare to
         * @param second the second string to compare to
         * @returns a list of all subtasks that are common between the two strings
         */ 
        public List<Task> findSameSubtasks(Task other)
        {
            List<Task> sublists=new List<Task>();
            List<string> sub_task = new List<string>();
            Comparision comp = equality;
            double[,] recur = this.buildRecurrance(other.getTask().ToArray(), comp, true);

            //Next, we go through the matrix, looking for 1s
            for (int i = 0; i < this.task_string.Count()-1; i++)
            {
                for(int j = 0; j < other.getSize()-1; j++)
                {
                    if (recur[i, j] == 1.0)//First, we check if we found a match
                    {
                        //Then, we check if are at a beginning piece (i.e connector)
                        if (connectives.ContainsKey(this.task_string[i]) && recur[i+1,j+1] == 1.0)
                        {
                            sub_task.Clear();//We need a clean task to do this   
                            sub_task.Add(this.task_string[i+1]);
                            sub_task.Add(this.task_string[i]);
                            bool finished = false;
                            int m = i-1;
                            int n = j - 1;
                            while (m > -1 && n > -1 && !finished)
                            {
                                if (recur[m, n] == 1.0)
                                {
                                    sub_task.Add(this.task_string[m]);
                                }
                                else
                                {
                                    finished = true; //For finding the same subtasks, we only care about how far we've gone in the diagonal for i
                                }
                                m -= 1;
                                n -= 1;
                            }
                            //Three cases, we get a perfect match, it's a false match, or it's too long a match
                            Task new_task = new Task("sub");
                            sub_task.Reverse();
                            new_task.setList(sub_task);
                            if (new_task.checkTask()) //Perfect Match
                            {
                                sublists.Add(new_task);
                            }
                            else //Other cases, let's see if it's too long
                            {
                                new_task.fixTask();
                                if (new_task.getSize() != 0)
                                {
                                    sublists.Add(new_task);
                                }
                            }
                        } 
                    }
                }
            }
            return sublists;
        }
        //Getters section
        public int getSize() { return task_string.Count(); }

        public void setNode(string item, int i)
        {
            task_string.RemoveAt(i);
            task_string.Insert(i,item);
        }
        public void addNode(string item)
        {
            task_string.Add(item);
        }
        public string getNode(int i)
        {
            if (this.task_string.Count() < i)
            {
                return "";
            }
            return this.task_string.ElementAt(i);
        }
        public void setList(List<string> flattened_list)
        {
            foreach (string i in flattened_list)
            {
                this.task_string.Add(i);
            }
        }

        public List<string> getTask() { return this.task_string; }

        public string getName() { return this.task_name; }
        //END OF CLASS DEFINITION
    }
}
