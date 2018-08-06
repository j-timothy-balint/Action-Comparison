using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MySql.Data;
using System.Data;

namespace TaskTester
{
    class database
    {
        private System.Data.DataSet task;
        private System.Data.DataSet task_actions;
        private System.Data.DataSet actions;
        private System.Data.DataSet objects;
        private System.Data.DataSet affordances;
        private string conn_string = "server=localhost;uid=root;pwd=root;database=parmanager";
        private MySql.Data.MySqlClient.MySqlConnection conn;
        
        //Look at adding dataset
        public database()
        {
            conn = new MySql.Data.MySqlClient.MySqlConnection(conn_string);
            conn.Open();
            MySql.Data.MySqlClient.MySqlDataAdapter t;
            string query = "SELECT * from task where 1";
            t = new MySql.Data.MySqlClient.MySqlDataAdapter(query,conn);
            task = new System.Data.DataSet();
            t.Fill(task, "Task");
            query = "SELECT * from task_actions where 1";
            t = new MySql.Data.MySqlClient.MySqlDataAdapter(query, conn);
            task_actions = new System.Data.DataSet();
            t.Fill(task_actions, "Task Actions");
            query = "SELECT * from action WHERE 1";
            t = new MySql.Data.MySqlClient.MySqlDataAdapter(query, conn);
            actions = new System.Data.DataSet();
            t.Fill(actions, "Actions");
            query = "SELECT * from object WHERE 1";
            t = new MySql.Data.MySqlClient.MySqlDataAdapter(query, conn);
            this.objects = new System.Data.DataSet();
            t.Fill(this.objects, "Objects");
            query = "SELECT * from obj_act WHERE 1";
            t = new MySql.Data.MySqlClient.MySqlDataAdapter(query, conn);
            this.affordances = new System.Data.DataSet();
            t.Fill(this.affordances, "Affordances");
        }

        public string getTask(int act_id)
        {
            System.Data.DataTable tab = this.task.Tables["Task"];
            var query = from t in tab.AsEnumerable()
                        where t.Field<int>("action_id")== act_id
                        select t.Field<string>("task_string");
            return (string)query.FirstOrDefault();
            /*string query = "SELECT task_string from task where act_id = " + act_id.ToString() + " LIMIT 1";
            MySql.Data.MySqlClient.MySqlCommand com = new MySql.Data.MySqlClient.MySqlCommand(query, this.conn);
            object result = com.ExecuteReader();
            if (result != null)
            {
                return Convert.ToString(result);
            }*/
            //return "";
        }
        public int[] getAllTaskActions()
        {
            System.Data.DataTable tab = this.task.Tables["Task"];
            var query = from t in tab.AsEnumerable()
                        select t.Field<int>("action_id");
            int rows = query.Count();
            int[] acts = new int[rows];
            int counter = 0;
            foreach (int act in query)
            {
                acts[counter] = act;
                counter += 1;
            }
            return acts;
        }
        public int[] getRoleObjects(int act_id, int pos)
        {
            System.Data.DataTable tab = this.affordances.Tables["Affordances"];
            var query = from t in tab.AsEnumerable()
                        where t.Field<UInt32>("act_id") == act_id
                        select t.Field<UInt32>("obj_id");
            int[] objs = new int[query.Count()];
            int count = 0;
            foreach (int o in query)
            {
                objs[count] = o;
                count += 1;
            }
            return objs;
        }

        public int getNumRoles(int act_id)
        {
            System.Data.DataTable tab = this.actions.Tables["Actions"];
            int roles = 0;
            var query = from t in tab.AsEnumerable()
                        where t.Field<UInt32>("act_id") == act_id
                        select t.Field<int>("act_obj_num");
            roles = query.First();
            return roles;
        }
        public int[] getAllPrimitives(int act_id)
        {
            System.Data.DataTable tab = this.task_actions.Tables["Task Actions"];
            var query = from t in tab.AsEnumerable()
                        where t.Field<int>("action_id") == act_id
                        orderby t.Field<int>("task_position")
                        select t.Field<int>("task_id");
            int rows = query.Count();
            int[] prims = new int[rows];
            int counter = 0;
            foreach (int p in query)
            {
                prims[counter] = p;
                counter += 1;
            }
            return prims;
         
        }

        public int[] getAllParents(int act_id,bool actions)
        {
            System.Data.DataTable tab;
            if (actions)
            {
                tab = this.actions.Tables["Actions"];
            }
            else
            {
                tab = this.objects.Tables["Objects"];
            }
            List<int> first_parents = new List<int>();
            int traveler = act_id;
            while (traveler != -1)
            {
                first_parents.Add(traveler);
                if (actions)
                {
                    var query = from t in tab.AsEnumerable()
                                where t.Field<UInt32>("act_id") == traveler
                                select t.Field<Int64>("parent_id");
                    if (query.Count() == 0)
                    {
                        traveler = -1;
                    }
                    else
                    {
                        traveler = (int)query.First();
                    }
                }
                else
                {
                    var query = from t in tab.AsEnumerable()
                                where t.Field<UInt32>("obj_id") == traveler
                                select t.Field<int>("parent_id");
                    if (query.Count() == 0)
                    {
                        traveler = -1;
                    }
                    else
                    {
                        traveler = query.First();
                    }

                }
            }
            return first_parents.ToArray();
        }
        public int depth(int id,bool false_root,bool actions)
        {
            //False root is set to true if we are considering that disjoint forests have a false root
            int traveler = id;
            int depth = 0;
            System.Data.DataTable tab;
            if (actions)
            {
                tab = this.actions.Tables["Actions"];
            }
            else
            {
                tab = this.objects.Tables["Objects"];
            }
            while (traveler != -1)
            {
                depth += 1;
                
                if (actions)
                {
                    var query = from t in tab.AsEnumerable()
                                where t.Field<UInt32>("act_id") == traveler
                                select t.Field<Int64>("parent_id");
                    if (query.Count() == 0)
                    {
                        traveler = -1;
                    }
                    else
                    {
                        traveler = (int)query.First();
                    }
                }
                else
                {
                    var query = from t in tab.AsEnumerable()
                            where t.Field<UInt32>("obj_id") == traveler
                            select t.Field<int>("parent_id");
                    if (query.Count() == 0)
                    {
                        traveler = -1;
                    }
                    else
                    {
                        traveler = query.First();
                    }
                }
            }
            if (false_root)
            {
                return depth + 1;
            }
            else
            {
                return depth;
            }
        }


        public double wuPalmerSim(int first, int second,bool action)
        {
            int []first_parents = this.getAllParents(first,action);
            int[] second_parents = this.getAllParents(second,action);
            int lcs_depth = 1;
            var query = from f in first_parents
                        where second_parents.Contains(f)
                        orderby f ascending
                        select f;
            if (query.Count() > 0)
            {
                lcs_depth = this.depth(query.First(), true,action);
            }
            int first_depth = this.depth(first, true,action);
            int second_depth = this.depth(second, true,action);

            return 2.0 * lcs_depth / (first_depth+second_depth);
        }

        /*Similarity Scores*/
        public double getRoleSimularity(List<Role> first, List<Role> second)
        {
            int f = first.Count();
            int s = second.Count();
            int i = 0; //Intersection
            if (f == 0 && s == 0)
            {
                return 1.0; //If they both have no roles, then they are similar
            }
            List<Role> second_copy = second.ToArray().ToList(); //This should deepcopy
            foreach (Role r in first)
            {
                var query = from role in second_copy
                            where role == r
                            select role;
                if (query.Count() > 0)
                {
                    i += 1;
                    //Here, we remove the one that we no longer want
                    second_copy.Remove(query.First());
                }
            }
            return (double)(f + s - 2*i)/(f+s - i);
        }
        //Especially for the act ids
        public List<Role> getAllRoles(int act_id, bool all_parents = true)
        {
            System.Data.DataTable tab = this.affordances.Tables["Affordances"];
            var query = from t in tab.AsEnumerable()
                        where t.Field<UInt32>("act_id") == act_id
                        orderby t.Field<UInt16>("obj_num")
                        select new { obj = t.Field<UInt32>("obj_id"), pos = t.Field<UInt16>("obj_num") };
            List<Role> roles = new List<Role>();
            foreach (var q in query)
            {
                if (q.pos > roles.Count() - 1)
                { //We start at zero
                    roles.Add(new Role());
                }
                roles.ElementAt((int)q.pos).addItem((int)q.obj);
                if (all_parents)
                {
                    int[] parents = this.getAllParents((int)q.obj, false);
                    foreach (int p in parents)
                    {
                        roles.ElementAt((int)q.pos).addItem(p);
                    }
                }
            }
            return roles;
        }

        public double taskSimilarity(string act1, string act2)
        {
            int a1=-1; 
            int.TryParse(act1,out a1);
            int a2=-1; 
            int.TryParse(act2,out a2);
            if (a1 == -1 || a2 == -1)
            {
                if (act1 == act2)
                {
                    return 1.0;
                }
                else
                {
                    return 0.0;
                }
            }
            return this.taskSimilarity(a1, a2);
        }
        public double taskSimilarity(int act1, int act2)
        {
            double result = this.wuPalmerSim(act1, act2, true);
            List<Role> role1 = this.getAllRoles(act1);
            List<Role> role2 = this.getAllRoles(act2);
            result += this.getRoleSimularity(role1, role2);

            return result/2.0; //For now, average the two together
        }

        public double taskCost(string act1, string act2, bool con1, bool con2)
        {
            if (con1 == true && con2 == true)
            {
                return Math.Abs(int.Parse(act1) - int.Parse(act2));
            }
            else if (con1 == true || con2 == true)
            {
                return 1.0;
            }
            else
            {
                int a1 = -1;
                int.TryParse(act1, out a1);
                int a2 = -1;
                int.TryParse(act2, out a2);
                if (a1 == -1 || a2 == -1)
                {
                    if (act1 == act2)
                    {
                        return 0.0;
                    }
                    else
                    {
                        return 1.0;
                    }
                }
                else
                {
                    return this.taskCost(a1, a2,con1,con2);
                }
            }
        }
        public double taskCost(int act1, int act2, bool con1, bool con2)
        {
            double result = this.wuPalmerSim(act1, act2, true);
            List<Role> role1 = this.getAllRoles(act1);
            List<Role> role2 = this.getAllRoles(act2);
            result += (this.getRoleSimularity(role1, role2)/Math.Max(role1.Count,role2.Count));

            return result / 2.0; //For now, average the two together
        }

        public double taskExactCost(string act1, string act2, bool con1, bool con2)
        {
            if (con1 == true && con2 == true)
            {
                return Math.Abs(int.Parse(act1) - int.Parse(act2));
            }
            else if (con1 == true || con2 == true)
            {
                return 1.0;
            }
            else
            {
                int a1 = -1;
                int.TryParse(act1, out a1);
                int a2 = -1;
                int.TryParse(act2, out a2);
                if (a1 == -1 || a2 == -1)
                {
                    if (act1 == act2)
                    {
                        return 0.0;
                    }
                    else
                    {
                        return 1.0;
                    }
                }
                else
                {
                    return this.taskExactCost(a1, a2, con1, con2);
                }
            }
        }
        public double taskExactCost(int act1, int act2, bool con1, bool con2)
        {
            double result = 0.0;
            if(act1 != act2)
            {
                result = 1.0;
            }
            List<Role> role1 = this.getAllRoles(act1);
            List<Role> role2 = this.getAllRoles(act2);
            result += this.getRoleSimularity(role1, role2);

            return result / 2.0; //For now, average the two together
        }

        public double taskLevenCost(string act1, string act2, bool con1, bool con2)
        {
            if (act1 == act2)
             {
                 return 0.0;
             }
             else
             {
                 return 1.0;
              }
        }

    }
}
