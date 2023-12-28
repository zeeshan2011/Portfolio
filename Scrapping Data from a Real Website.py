#!/usr/bin/env python
# coding: utf-8

# # Web Scrapping from a Real Website

# In[1]:


from bs4 import BeautifulSoup


# In[3]:


import requests


# In[4]:


url = 'https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue'


# In[5]:


page = requests.get(url)


# In[6]:


soup = BeautifulSoup(page.text, 'html')


# In[14]:


soup.find_all('table', class_= 'wikitable sortable')
#or can be done with this way
# soup.find_all('table')[1]


# In[39]:


table = soup.find_all('table')[1]


# In[41]:


table.find_all('th') 
# doest not work with the other method 
# soup.find_all('table', class_= 'wikitable sortable')


# In[42]:


world_titles = table.find_all('th')


# In[43]:


#looping throup and putting all the titles in a list
world_titles_list = []
for title in world_titles:
    print(title.text.strip())
    world_titles_list.append(title.text.strip())
    


# In[45]:


print(world_titles_list)


# In[46]:


import pandas as pd


# In[93]:


df = pd.DataFrame(columns = world_titles_list)


# In[94]:


column_data = table.find_all('tr')


# In[96]:


len(df)


# In[97]:


for data in column_data[1:]:
    row_data = data.find_all('td')
    individual_row_data = [row.text.strip() for row in row_data]
    #print(individual_row_data)
    
    length = len(df)
    df.loc[length] = individual_row_data


# In[104]:


pd.options.display.max_rows = 9999


# In[106]:


df.info()


# In[107]:


df


# In[109]:


df.to_csv(r'C:\Users\pshan\Desktop\Pandas Demo\ companies.csv', index = False)


# # 2nd table

# In[112]:


table2 = soup.find_all('table')[2]


# In[121]:


titles2 = table2.find_all('th')
table2_titles = []
for title in titles2:
    table2_titles.append(title.text.strip())


# In[122]:


table2_titles


# In[123]:


df2 = pd.DataFrame(columns = table2_titles)


# In[124]:


df2


# In[127]:


column2_data = table2.find_all('tr')


# In[131]:


for data in column2_data[1:]:
    row2_data = data.find_all('td')
    individual_row2_data = [row.text.strip() for row in row2_data]
    print(individual_row2_data)
    
    length = len(df2)
    df2.loc[length] = individual_row2_data


# In[132]:


df2


# In[133]:


df2.to_csv(r'C:\Users\pshan\Desktop\Pandas Demo\ Largest Companies.csv', index = False)


# # Largest Companies by Profit 

# In[134]:


table3 = soup.find_all('table')[3]


# In[137]:


table3_titles = table3.find_all('th') 


# In[138]:


table3_titles_list = [title.text.strip() for title in table3_titles]
    


# In[139]:


table3_titles_list


# In[142]:


df3 = pd.DataFrame(columns = table3_titles_list)


# In[148]:


df3


# In[149]:


column3_data = table3.find_all('tr')


# In[152]:


for data in column3_data[1:]:
    row3_data = data.find_all('td')
    individual_row3_data = [row.text.strip() for row in row3_data]
    #print(individual_row3_data)
    length = len(df3)
    df3.loc[length] = individual_row3_data


# In[153]:


df3


# In[154]:


df3.to_csv(r'C:\Users\pshan\Desktop\Pandas Demo\Largest Companies by Profit.csv', index = False)


# In[ ]:




