using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TaskTester
{
    class Effect
    {
        private List<string> effects;

        public Effect()
        {
            this.effects = new List<string>();
        }
        public int getNum() { return this.effects.Count(); }
        public void addEffect(string effect)
        {
            this.effects.Add(effect);
        }
        public void setEffect(string effect, int index)
        {
            if (index > -1 && index < effects.Count())
            {
                this.effects.RemoveAt(index);
                this.effects.Insert(index, effect);
            }
        }
        public string getEffect(int index)
        {
            if (index < 0 || index > this.effects.Count() - 1)
            {
                return "";
            }
            return this.effects.ElementAt(index);
        }
        public bool Contains(string item)
        {
            foreach (string i in this.effects)
            {
                if (i == item)
                {
                    return true;
                }
            }
            return false; 
        }

        public static bool operator ==(Effect first, Effect second)
        {

            if (first.getNum() != second.getNum())
            {
                return false;
            }
           
            for (int i = 0; i < first.getNum(); i++)
            {
                if (!second.Contains(first.getEffect(i)))
                {
                    return false;
                }
            }

            return true;
        }

        public static bool operator !=(Effect first, Effect second)
        {

            if (first.getNum() != second.getNum())
            {
                return true;
            }

            for (int i = 0; i < first.getNum(); i++)
            {
                if (!second.Contains(first.getEffect(i)))
                {
                    return true;
                }
            }

            return false;
        }
    }
}
