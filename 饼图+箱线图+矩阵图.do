** 圆形/饼图
* 两个或以上变量的饼图
gen edu1=educ<=6 //使用之前在条形堆积图里面的分层方法
gen edu2=educ>6 & educ<=12 //此处及以下通过教育年限粗略划分小学、中学、本科阶段
gen edu3=educ>6 & educ<=12
gen edu4=educ>12 & educ<=16
gen edu5=educ>16
graph pie edu1 edu2 edu3 edu4 edu5 //这几个变量占比加在一起为1

* 个案取值：扇形可以直观地展现变量每个分类的占比
graph pie, over(married) //over 每个扇面代表变量的某个取值
graph pie, over(married) by(gender) //可以分不同的组别
graph pie, over(gender) by(married) //调换一下试试看，也是可以的
graph pie, over(married) pie(1,explode color(red)) pie(3,explode color(blue)) //突出标识某取值，并且设置为红色；可以同时设置多个
graph pie, over(married) pie(1,explode color(red)) pie(3,explode color(blue)) plabel(_all name) //把所有扇面的名字加上
graph pie, over(married) pie(1,explode color(red)) pie(3,explode color(blue)) plabel(_all percent) //给所有扇面附上百分比
graph pie, over(married) pie(1,explode color(red)) pie(3,explode color(blue)) plabel(_all percent, size(*0.8) gap(9) format(%9.2f)) //可以设置小数点、百分比显示位数以及

** 箱线图
*如何理解箱线图：盒子中间的横线是中位数，封闭盒子上下两条横线是上下四分位数，上下端横线位变量最大/小值；超过盒长3倍的被认为是极端值
sum height weight //平均身高163，平均体重121
graph box height weight, over(gender) yline(163, lwidth(0.3) lstyle(foreground)) yline(121, lwidth(0.3) lcolor(green)) //我们根据平均值画一条横线，lwidth设置粗细，lstyle设置风格，这里的意思是说与盒子一致，lcolor设置颜色
graph hbox height weight, over(gender) //通过hbox设为横的
graph box educ, over(gender) by(hk) //还可以再分不同的组别

** 矩阵图
graph matrix height weight age //两两对应关系
egen m_height=mean(height), by(age) //用到在线图中的整理方法
egen m_weight=mean(weight), by(age) 
label variable m_height "年龄身高均值（厘米）"
label variable m_weight "年龄体重均值（斤）"
graph matrix m_height m_weight age //对应坐标的时候一定注意它们的增长方向
graph matrix m_height m_weight age, half msymbol(oh) //显示一半的矩阵，用空心圆圈来表达
corr m_height m_weight age //相关系数矩阵，可以更精确地看到相关关系大小和方向
corr m_height m_weight age if age>0 & age<=35 //再聚焦0-35岁阶段，发现正相关，特别是height与age之间

