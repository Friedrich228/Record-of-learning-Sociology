**# 变量的生成与处理 #**
** 利用命令生成新变量：gen egen（extended generate）replace recode
replace cfps2020eduy=. if cfps2020eduy==-9 //replace对现有数据进行直接处理。此处将取值为-9的"缺失"的处理为缺失值
drop if edu==.
tab cfps2020eduy //看一下效果
gen edu=cfps2020eduy //创建我们熟悉的变量名，所有取值与处理后的"最高教育年限"相等
tab edu //情况相符
rename cfps2020eduy educy //也可以用rename，新的变量标签将覆盖原变量标签
tab educy //情况相符
recode edu(0=0)(1/6=1)(7/9=2)(10/12=3)(13/16=4)(17/24=5), gen(edu_level) //利用recode重新赋值原数值型变量，后跟gen可在此基础上创建新变量。这里根据教育年限划分不同的教育层级，仅作例子参考，不具备实质含义
tab edu_level //查看情况
gen educ_level=0 //创建分类变量（实际上，上面的recode+gen已经能够一步到位处理，这里是拆解版的步骤）
replace educ_level=0 if edu==0
replace educ_level=1 if 1<=edu & edu<=6
replace educ_level=2 if 7<=edu & edu<=9
replace educ_level=3 if 10<=edu & edu<=12
replace educ_level=4 if 13<=edu & edu<=16
replace educ_level=5 if 17<=edu & edu<=24
tab educ_level

* 特别强大的egen
egen age_group = cut(age), at(7,13,16,20,35,60) //cut表示分割某变量，at限定每个组的下限。所有小于第一个数的和大于等于最后一个数的都会被处理为缺失值。这样生成的变量为分类变量（其实和replace+gen的功能一样）
tab age_group
egen age_mean=mean(age), by(gender) //按照某变量的分类来生成均值，有很多计算函数median kurt iqr四分位数 sd max min
tab age_mean
egen ugirl=concat(urban20 gender), decode p(/) //concat合并变量，decode改变现有变量格式，p()允许在数值之间加入分隔符，可自定义
list urban20 gender ugirl in 1/10 //查看一下变量情况（这个还是蛮实用的，可以用来交叉分类） 
egen ubgirl=group(gender urban20), missing label lname("性别户口变量") //按group内的变量对现存变量进行交叉分类，形成组群变量；missing表示也将.纳入分类而不是视为缺失值从而不去处理；label新变量使用原变量数值的值标签；lname给新变量设置标签
list urban20 gender ubgirl in 1/10 //数据量太庞大，看前10个即可


** 利用序号生成新变量：_n _N与它们的变形 _n现有排序序次，_N最后一个排序序次
bysort edu: gen order=_n //新变量的取值等于组内观察值的排序序号，比如受访者a的教育年限为12，则其取值就为在同样教育年限为12的组内的排序序号
sort order //按由大到小排列
tab order in 1/100 //发现问题：取值为1的竟然有26个，但教育分组却只有25组，说明缺失值被算上了所以要先运行 drop if edu==. 再来创建order。再次运行，发现没问题了
bysort fid20: gen f_members=_N //_N代表某组最后一个值的排序序次，这个命令的意思是，按照2020年家庭代码来分组，取每个组内最大的序号，代表受访家庭成员个数。逻辑：同一家人的家庭代码相同，可归为一组；取最大的序号，代表家里共有多少人参与调查
ta f_members //参与人数最多的家庭，有10位加入了调查