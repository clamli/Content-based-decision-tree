## Content-based decision tree
#### Basic ideas
- Content information
- Active learning method (user rating information)
#### Dataset
- movielens 20M
- movielens 1M
#### Basic steps
- IMDb crawler: 
1. Crawl movies tag information from IMDb by IMDb number provided by movielens.
2. Clean and generate different kinds of data used by later steps. (all of the following information contains 1M and 20M movielens data, only use 20M movielens as example. Detailed data information can be found here [data overview](https://github.com/clamli/Content-based-decision-tree/blob/master/IMDb%20crawler/data_overview.ipynb).)
	1) Movies year information:
   ```
   dict { 
   		movieid(str) : year(int) 
   };
   ```
   2) Movies title information:
   ```
   dict { 
   		movieid(str) : movie title(str) 
   };
   ```
   3) Movies genre information:
   In movielens 20M, 70 movies miss genre(can't found on IMDb either).
   In movielens 1M, 0 movies miss genre.
   ```
   dict { 
   		movieid(str) : genre(lst) 
   };
   ```
   4) Movies tag information:
   In movielens 20M, 594 movies miss tags(can't found on IMDb either).
   In movielens 1M, 12 movies miss tags.
   ```
   dict { 
   		movieid(str) : tags(str) 
   };
   ```
#### Dependence
- Python 3.5