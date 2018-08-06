using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace TaskTester
{
    class Program
    {
        static database db;
        //Writes out the confusion matrix to a file
        static void writeConfusionMatrix(double[,] result, string[] object_names, string file_name)
        {
            //Note that our object_names represent the 
            using (System.IO.StreamWriter file =
                new System.IO.StreamWriter(@file_name))
            {
                //First, write out all objects
                file.WriteLine(" ,"+string.Join(",", object_names));
                for(int i=0; i < object_names.Length; i++)
                {
                    file.Write(object_names[i] + ",");
                    for(int j = 0; j < object_names.Length; j++)
                    {
                        file.Write(result[i,j].ToString());
                        if(j < object_names.Length - 1)
                        {
                            file.Write(",");
                        }
                    }
                    file.Write("\n");
                }
            }
        }

        static double[,] calculateResults(List<Task> all_tasks,contextCompare comp)
        {
            double [,] results = new double[all_tasks.Count(), all_tasks.Count()];
            for (int i = 0; i < all_tasks.Count(); i++)
            {
                results[i, i] = 0.0;
                for (int j = i + 1; j < all_tasks.Count(); j++)
                {
                    double sim = all_tasks[i].getCost(all_tasks[j], comp);
                    results[i, j] = sim;
                    results[j, i] = sim;
                }
            }
            return results;
        }
        static double[,] calculateMaxResults(List<Task> all_tasks, contextCompare comp)
        {
            double[,] results = new double[all_tasks.Count(), all_tasks.Count()];
            for (int i = 0; i < all_tasks.Count(); i++)
            {
                results[i, i] = 1.0;
                for (int j = i + 1; j < all_tasks.Count(); j++)
                {
                    double sim = 1.0 - all_tasks[i].getCostMaxLength(all_tasks[j], comp);
                    results[i, j] = sim;
                    results[j, i] = sim;
                }
            }
            return results;
        }
        static double[,] calculateComponents(int [] task_ids)
        {
            double[,] results = new double[task_ids.Length, task_ids.Length];
            for (int i = 0; i < task_ids.Count(); i++)
            {
                //results[i, i] = 0.0;
                for (int j = i; j < task_ids.Length; j++)
                {
                    double sim = db.getRoleSimularity(db.getAllRoles(task_ids[i],false), db.getAllRoles(task_ids[j]));
                    results[i, j] = sim;
                    results[j, i] = sim;
                }
            }
            return results;
        }

        static void Main(string[] args)
        {
            /*
            */
            db = new database();
            int []acts = db.getAllTaskActions();
            List<string> task_names = new List<string>();
            List<Task> all_tasks = new List<Task>();
            foreach (int act in acts)
            {
                int[] prims = db.getAllPrimitives(act);
                string task = db.getTask(act);
                task_names.Add(task);
                Task t = new Task(task);
                t.pdaToList(task, prims);
                all_tasks.Add(t);
            }
            //behavior general
            double[,] results = calculateMaxResults(all_tasks, db.taskCost);
            writeConfusionMatrix(results, task_names.ToArray(), "behavior_general.csv");
            //behavior exact
            results = calculateMaxResults(all_tasks , db.taskExactCost);
            writeConfusionMatrix(results, task_names.ToArray(), "behavior_exact.csv");
            //behavior leven
            results = calculateMaxResults(all_tasks , db.taskLevenCost);
            writeConfusionMatrix(results, task_names.ToArray(), "behavior_leven.csv");
            //components only exact
            results = calculateComponents(acts);
            writeConfusionMatrix(results, task_names.ToArray(), "component.csv");
            //components only general
            //results = calculateComponents(acts);
            //writeConfusionMatrix(results, task_names.ToArray(), "component_general.csv");
            //Console.WriteLine(db.taskSimilarity(acts[0], acts[1]).ToString());
            List<Task> lev_tasks = new List<Task>();
            foreach (int act in acts)
            {
                int[] prims = db.getAllPrimitives(act);
                string task = "";
                foreach(int p in prims){
                    task = task+"p";
                }
                Task t = new Task("a");
                t.pdaToList(task, prims);
                lev_tasks.Add(t);
            }
            results = calculateResults(lev_tasks, db.taskLevenCost);
            writeConfusionMatrix(results, task_names.ToArray(), "behavior_leven.csv");
            Console.ReadKey();
        }

        void debugCode()
        {
            Task parser = new Task("a");
            Task test = new Task("b");
            TreeNode root = new TreeNode("and");
            root.Nodes.Add("or");
            root.Nodes.Add("232");
            root.Nodes[0].Nodes.Add("232");
            root.Nodes[0].Nodes.Add("233");
            root.Nodes[0].Nodes.Add("while");
            root.Nodes[0].Nodes[2].Nodes.Add("123");
            root.Nodes[0].Nodes[2].Nodes.Add("123");
            root.Nodes[0].Nodes.Add("233");
            parser.convertTreeToFlattenedList(root);
            if (parser.checkTask())
            {
                Console.WriteLine(parser.convertToPDA());
                string[] actions = parser.getSymbols();
                test.pdaToList(parser.convertToPDA(), actions);
                for (int i = 0; i < actions.Count(); i++)
                {
                    Console.Write(actions[i] + " ");
                }
                Console.WriteLine("");
            }
            else
            {
                Console.WriteLine("This one is broken");
            }
            //Next test, sublists
            Task new_task = new Task("a");
            TreeNode reflex = new TreeNode("and");
            reflex.Nodes.Add("indy");
            reflex.Nodes.Add("indy");
            reflex.Nodes[0].Nodes.Add("1");
            reflex.Nodes[0].Nodes.Add("2");
            reflex.Nodes[1].Nodes.Add("1");
            reflex.Nodes[1].Nodes.Add("2");
            new_task.convertTreeToFlattenedList(reflex);
            if (parser.checkTask())
            {
                List<Task> all_subs = new_task.findSameSubtasks(new_task);
                string[] actions;
                foreach (Task sub in all_subs)
                {
                    if (sub.checkTask())
                    {
                        Console.WriteLine(sub.convertToPDA());
                        actions = sub.getSymbols();
                        for (int i = 0; i < actions.Count(); i++)
                        {
                            Console.Write(actions[i] + " ");
                        }
                        Console.WriteLine("");
                    }
                    Console.WriteLine("Finished one");
                }
            }
            else
            {
                Console.WriteLine("Fix Reflex");
            }
            Effect eff = new Effect();
            eff.addEffect("changeContents(agent,key)");
            eff.addEffect("setProperty(agent,'status','idle')");
            Effect ef2 = new Effect();
            ef2.addEffect("changeContents(agent,key)");
            ef2.addEffect("setProperty(agent,'status','idle')");
            if (eff == ef2)
            {
                ef2.setEffect("setProperty(agent,'status','standing')", 1);
                if (eff != ef2)
                {
                    Console.WriteLine("Effects are working");
                }
                else
                {
                    Console.WriteLine("effects are not working");
                }
            }
            else
            {
                Console.WriteLine("Effects are not working");
            }
        }
    }
}
