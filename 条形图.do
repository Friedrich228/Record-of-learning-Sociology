** 条形图
//y是连续变量，x可以是分类/连续变量
graph bar m_income, over(educ) //按教育年限分类来描述月收入均值（默认描述y的均值）这里的m_income有个别异常值，如educ对应20年和21年的；我们根据常识能够判断，16年一般对应本科毕业，19年对应硕士毕业，22及以上对应博士毕业，故而在这些时间节点区间出现的年份，受访者可能辍学或经历其它社会事件，与按照既定路线完成学业的调查对象有所不同。这里只是提供绘图命令和一些注意事项，具体的数据清洗和现实含义，前者见另外的文档，后者视自身研究实际而确定。
graph bar educ, over(gender) //不能忽略over或by选择，不然其结果默认为求均值，和sum没区别
graph bar m_income if age>=18 & age<=35 & educ!=. ,over(educ) //可以自定义很多其它限制条件
graph hbar m_income, over(educ) //可以通过这个命令变成横着的
graph bar (sd) m_income, over(educ) //在y前用()指定呈现哪个统计量：median sd sum iqr四分位差 count min max
graph bar (median) m_income, over(educ) //中位数
graph bar (sum) m_income, over(educ) //算术和
graph bar (iqr) m_income, over(educ) //四分位差
graph bar (count) m_income, over(educ) //计数
graph bar (min) m_income, over(educ) //最小值
graph bar (max) m_income, over(educ) //最大值

**# 原始数据有问题，这里的标签出错了
graph bar m_income, over(gender, label(labsize(*1.2) labcolor(blue)) descending reverse) ytitle("月收入") //此处值标签有问题，应当回到原始数据中去处理解决 descending和reverse任意选一个，bar由高到低排列x的取值，两个同时用，就相当于没有使用这个命令

graph bar m_income, over(gender, label(labsize(*1.2) labcolor(blue))) ytitle("月收入") by(hk) //by是在over分组基础上重复分组，也可以用两次over，效果是差不多的
graph bar m_income, over(gender, label(labsize(*1.2) labcolor(blue))) ytitle("月收入") over(hk) //by是在over分组基础上重复分组，也可以用两次over，效果是差不多的

*堆积图（stack）
gen edu1=educ<=6 //多个变量y上下堆积，一般来说它们是由同一个y派生而来的，比如从教育年限划分出教育水平或阶段
gen edu2=educ>6 & educ<=12 //此处及以下通过教育年限粗略划分小学、中学、本科阶段，为之后的堆积图做准备
gen edu3=educ>6 & educ<=12
gen edu4=educ>12 & educ<=16
gen edu5=educ>16
graph bar (mean) edu1 edu2 edu3 edu4 edu5, over(hk) stack legend(row(2)) blabel(bar, position(base) format(%4.2f)) percentages over(gender) //stack要求堆积各部分占比，format指定bar的数值显示两个小数位；percentage告诉stata，y轴上的统计量是百分比,blabel(bar)在条柱上添加变量取值（占的百分比）
graph bar (mean) edu1 edu2 edu3 edu4 edu5, over(hk) stack blabel(name, format(%4.2f)) percentages over(gender) legend(off) //blabel(name)会在条柱上显示色块的名称，就不用legend图例了
graph bar m_income, over(married, axis(off)) by(gender) blabel(group) //可以用blabel(group)使条柱显示x轴的值，在over里面设置去掉x轴
graph bar (mean) m_income, over(educ) blabel(bar, position(base) size(*0.8) format(%4.1f)) //标签内容、位置、格式都放在一个括号内。其它关于颜色、边距的设定，视情况而进行自定义，参考stata语法说明
graph bar (mean) m_income, over(educ) blabel(bar, position(base) size(*0.8) format(%4.1f)) by(hk) yline(10000) //yline添加辅助线，便于进行比较

