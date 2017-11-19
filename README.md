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
	2. Clean and generate different kinds of data used by later steps. *(All of the following information contains 1M and 20M movielens data, only use 20M movielens as example. Detailed data information can be found here [data overview](https://github.com/clamli/Content-based-decision-tree/blob/master/IMDb%20crawler/data_overview.ipynb).)*

	   **1) Movies year information:**
	   ```
	   dict { 
			movieid(str) : year(int) 
	   };
	   ```
	   **2) Movies title information:**
	   ```
	   dict { 
			movieid(str) : movie title(str) 
	   };
	   ```
	   **3) Movies genre information:** <br>
	   In movielens 20M, 70 movies miss genre(can't found on IMDb either).
	   In movielens 1M, 0 movies miss genre.
	   ```
	   dict { 
			movieid(str) : genre(lst) 
	   };
	   ```
	   **4) Movies tag information:** <br>
	   In movielens 20M, 594 movies miss tags(can't found on IMDb either).
	   In movielens 1M, 12 movies miss tags.
	   ```
	   dict { 
			movieid(str) : tags(str) 
	   };
	   ```
- Step 3 - Item Similarity Information:
	- Year information: 
	```
	{ movieid : year(int) }
	```
	- Genre information:
	```
	{ movieid : array() }
	```
	Every feature of the array is a certain genre.
	- Title information:
	```
	sparse matrix: 3883x3940 (for 1M movielens)
	sparse matrix: 45843x25632 (for 20M movielens)
	```
	- Tag information:
	```
	sparse matrix: 3883x16935 (for 1M movielens)
	sparse matrix: 45843x42721 (for 20M movielens)
	```
#### Dependence
- Python 3.5