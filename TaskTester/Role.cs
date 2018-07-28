using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TaskTester
{
    class Role
    {
        private List<int> items;
        public Role()
        {
            items = new List<int>();
        }
        public void addItem(int id)
        {
            if(!items.Contains(id)) //Only add it if it doesn't exist
                items.Add(id);
        }
        public int getItem(int index)
        {
            if(index >= 0 && index < items.Count())
            {
                return items.ElementAt(index);
            }
            return -1;
        }
        public int getNum()
        {
            return items.Count();
        }


        public bool Contains(int item)
        {
            foreach (int i in items)
            {
                if (i == item)
                {
                    return true;
                }  
            }
            return false; 
        }
        

        public static bool operator == (Role first, Role second)
        {
            for (int i = 0; i < first.getNum(); i++)
            {
                if (second.Contains(first.getItem(i)))
                {
                    return true;
                }
            }

                return false;
        }

        public static bool operator !=(Role first, Role second)
        {
            for (int i = 0; i < first.getNum(); i++)
            {
                if (second.Contains(first.getItem(i)))
                {
                    return false;
                }
            }
            return true;
        }
    }
}
