using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TaskTester
{
    class Condition
    {
        private List<string> conditions;
        private bool success;

        public Condition()
        {
            this.conditions = new List<string>();
            this.success = false; //assume until set
        }
        public void setSucess(bool suc) { this.success = suc; }
        public bool getSucess() { return this.success; }
        public int getNum() { return this.conditions.Count(); }
        public void addCondition(string condition)
        {
            this.conditions.Add(condition);
        }
        public void setCondition(string condition, int index)
        {
            if (index > -1 && index < conditions.Count())
            {
                this.conditions.RemoveAt(index);
                this.conditions.Insert(index, condition);
            }
        }
        public string getCondition(int index)
        {
            if (index < 0 || index > this.conditions.Count() - 1)
            {
                return "";
            }
            return this.conditions.ElementAt(index);
        }
        public bool Contains(string item)
        {
            foreach (string i in this.conditions)
            {
                if (i == item)
                {
                    return true;
                }
            }
            return false; 
        }

        public static bool operator ==(Condition first, Condition second)
        {
            if (first.getSucess() != second.getSucess())
            {
                return false;
            }
            if (first.getNum() != second.getNum())
            {
                return false;
            }
           
            for (int i = 0; i < first.getNum(); i++)
            {
                if (!second.Contains(first.getCondition(i)))
                {
                    return false;
                }
            }

            return true;
        }

        public static bool operator !=(Condition first, Condition second)
        {
            if (first.getSucess() != second.getSucess())
            {
                return true;
            }
            if (first.getNum() != second.getNum())
            {
                return true;
            }

            for (int i = 0; i < first.getNum(); i++)
            {
                if (!second.Contains(first.getCondition(i)))
                {
                    return true;
                }
            }

            return false;
        }
    }
}
