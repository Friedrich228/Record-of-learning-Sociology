**# 数据基本情况了解 #**
describe //给出数据库基本情况：多少观察值obs，多少变量，存储格式，变量标签和取值标签等。CFPS2020样本量庞大，变量也多，未显示完全
describe, simple //只输出变量名
describe, short //只输出obs个数和变量个数，更为简洁
describe age gender //可以直接跟上变量名，只看它们的基本情况，但这个和sum不同，并不提供均值等信息
codebook age //查看变量缺失值、异常值、取值情况等
codebook age if gender==1 //还可以用if来限定条件，具体操作可"help if"进行搜索查看
codebook age if gender==1 in 1/1000 //取前1000个数据进行
inspect age //变量的0/负/正值个数，整数与非整数值的个数，还有频数分布草图
browse //帮你打开数据编辑器，但也可以手动点开
list party if gender==0 //默认列出所有变量和它们的所有取值
sort qz207 //默认从小到大排列，缺失值排最后。本例子选取标签为"智力水平"的变量qz207
gsort +qz207 //用gsort可以在变量前面加上加号，表示由大到小排列；不加符号或带上减号，就是由小到大排列
sort age gender party //排序的优先级从左至右
bysort gender:inspect age //根据某个变量的分类情况：来进行对另一个变量的某种描述
order age party gender //按所给顺序排列，插到所有变量前头
aroder //默认全部变量按字母排列
move party age //一次变两个，写在前面的排另一个前面（插队）
