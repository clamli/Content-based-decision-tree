import csv
import shelve
import pickle
import urllib.request
from bs4 import BeautifulSoup
import threading

class MyThread(threading.Thread):
	# @note: overwrite threading class to return value
	def __init__(self, func, args=()):
		super(MyThread, self).__init__()
		self.func = func
		self.args = args

	def run(self):
		self.result = self.func(*self.args)

	def get_result(self):
		try:
			return self.result
		except Exception:
			return None

def getHtml(url):
	try:
		with urllib.request.urlopen(url) as page:
			html = page.read()
			return html
	except:
		return ""

def getTags(html):
	soup = BeautifulSoup(html, 'html.parser', from_encoding='utf-8')
	# print(soup.findall('a', class_='sodatext'))
	tags_str = ""
	try:
		for tag_cont in soup.find_all('div', 'sodatext'):
			tags_str = tags_str + ' ' + tag_cont.a.string
		return tags_str
	except:
		return ""

#### Function to crawl movies tag from IMDb ####
''' movie_tags = { movieid: movie tags list } '''
def IMDb_crawler(movie_dict):
	movie_tags = {}
	for movieid in movie_dict:
		html = getHtml("http://www.imdb.com/title/tt%s/keywords"%movie_dict[movieid])
		movie_tags[movieid] = getTags(html)
		# print(movieid)
	# print("Thread Done!")
	return movie_tags


#### Read movies number out ####
''' movie_dict = { movieid: movie IMDb number } '''
movie_dict = {}
start = False
with open('./ml-latest/links.csv') as csvfile:
	reader = csv.reader(csvfile)
	for row in reader:
		if start is False:
			start = True
			continue
		movie_dict[row[0]] = row[1]
print("File Read Done!")
#### partition movie_dict into 20 subset to do multithread crawl ####
count = 0
movie_dict_set = []
sub_movie_dict = {}
for movieid in movie_dict:
	sub_movie_dict[movieid] = movie_dict[movieid]
	count += 1
	if count%500 == 0:
		movie_dict_set.append(sub_movie_dict)
		sub_movie_dict = {}
movie_dict_set.append(sub_movie_dict)
print("Split Done!%d"%len(movie_dict_set))   ## 92

#### Create multi-thread to crawl ####
for i in range(10):
	if i is not 9:
		left = 10*i
		right = 10*i + 9
	elif i is 9:
		left = 10*i
		right = 10*i + 1
	threads = []
	result_movie_tag_dict = {}
	for num in range(left, right+1):
		threads.append(MyThread(func=IMDb_crawler, args=(movie_dict_set[num],)))
	for t in threads:
		t.setDaemon(True)
		t.start()
	for t in threads:
		t.join()
		print(t.get_result())
		result_movie_tag_dict.update(t.get_result())
	# print(result_movie_tag_dict)
	with shelve.open("./movie-tags-20M/%d~%d.pkl"%(left, right), protocol=pickle.HIGHEST_PROTOCOL) as d:
		d["content"] = result_movie_tag_dict
	print("%d~%d Done!"%(left, right))

	


