using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TaskTester
{
    //This section is about comparing two task lists to find similarities between them
    public delegate double Comparision(string a, string b); //Our comparision delegate
    public delegate double contextCompare(string a,string b,bool first,bool second);//Does a comparision that is context aware
    class PAR
    {
        private Task task_exec; //The execution tree in flattened form
        private int act_id; //The action id
        private Dictionary<Condition, Task> task_prep; //The list of prep-spec trees
        private Dictionary<Condition, Effect> cone_effect; //The one-time effect
        private Dictionary<Condition, Effect> cevery_effect; //The every-time effects
        private List<Role> roles; //The list of object roles. The first one is always an agent
        public PAR(int actid)
        {
            this.act_id = actid;
            this.task_prep = new Dictionary<Condition, Task>();
            this.cone_effect = new Dictionary<Condition, Effect>();
            this.cevery_effect = new Dictionary<Condition, Effect>();
            this.roles = new List<Role>();
        }
        /*getter section*/
        public int getID() { return this.act_id; }
        public Task getExectTask() { return task_exec; }
        public Task getPrepTask(Condition cond){ return task_prep[cond];}
        public Effect getEffect(Condition cond) {
            if (cone_effect.ContainsKey(cond))
                {return cone_effect[cond];}
            else
                {return cevery_effect[cond];}
        }
        public List<Task> getAllPrepTasks() { return task_prep.Values.ToList(); }
        public List<Condition> getAllPrepCon() { return task_prep.Keys.ToList(); }
        public List<Condition> getAllOneCon() { return cone_effect.Keys.ToList(); }
        public List<Condition> getAllEveryCon() { return cevery_effect.Keys.ToList(); }
        public List<Effect> getAllOneEff() { return cone_effect.Values.ToList(); }
        public List<Effect> getAllEveryEff() { return cevery_effect.Values.ToList(); }
        public List<Role> getAllTasks() { return this.roles;}
        /*Setter Section*/
        public void addExecTask(Task task) { this.task_exec = task; }
        public void AddPrep(Condition cond, Task task) { this.task_prep[cond] = task; }
        public void AddOneConEff(Condition cond, Effect eff) { this.cone_effect[cond] = eff; }
        public void AddEveryConEff(Condition cond, Effect eff) { this.cevery_effect[cond] = eff; }
        public void addRole(Role role) { this.roles.Add(role); }

        public double getTaskSimularity(Task second, Comparision comp)
        {

            double result = this.task_exec.getSimularity(second, comp);

            return result;
        }
    }
}
