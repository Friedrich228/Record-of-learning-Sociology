**# 基本情况查看 #**
** 单变量频数分布：默认tab，或者tab1
tabulate gender //查看变量的频数分布 tabulate可简写为tab
tab gender,nolabel //隐藏值标签，看原始数值
tab gender,missing //将缺失值也显示出来
tab gender, nofreq //不显示频数
tab party, plot //生成简单的频数分布图
tab age, plot
tab party, missing nol freq plot //以上option可以一起用
bysort gender: tab party, nol //可以自由组合一些命令，非常灵活
tab urban20 in 200/300 //也可以看变量在某一个范围内的频数分布

** 多变量频数分布
tab1 gender party urban20 //一次性生成多个单变量频数分布表 tab后面是不可以接超过两个变量的

** 条件频数分布
tab gender party //默认第一个为行变量，第二个为列变量
tab gender party, chi2 //chi2两个关系的卡方（相互独立还是有相关）
tab gender party, colum //列变量的百分比 单元格频数占列total的百分比
tab gender party, row //行变量的百分比 单元格频数占行total的百分比
tab gender party, miss //缺失变量的比例
tab gender party, nokey //压缩单元格内的提示
tab gender party, chi2 colum row miss nokey //综合效果
tab2 gender party urban20 //三个变量两两组合看列联表
tab party urban20, expected //可输出期望值：期望的定义，就是假设行列变量互相独立的时候，计算它们同时发生的概率：（行合计频数*列合计频数）/总频数。这是一个理论值。卡方检验就是在此基础上进行的。上频数下期望，若差距过大，可初步判断二者存在相关
tab party urban20, chi2 //卡方检验，p值显著的话，拒绝原假设，认为二者存在相关，接下来要看关系的具体大小
tab party urban20, expected chi2 exact lrchi2 gamma taub V //各呈现了三种检验相关关系和计算相关关系大小的方法

** 集中趋势：众数、均值、中位数；离散趋势：四分位数、全距/极差、方差、标准差
summarize age gender urban20 party //简写为sum，可以一次性输出多个
sum age gender urban20 party, detail //可以查看详细信息，简写为de
table gender //仅输出频数 table可以汇总多个变量的统计量，自定义功能较强
table (gender party) (urban20 qn4004) //前面是多个行变量，后面是多个列变量
tabstat age qp101 //输出多个数值型变量的基本统计量，默认为均值，这里选的是年龄和身高
tabstat age qp101 qp102, statistic(mean sd) columns(statistics) //qp102是体重；statistic指定要哪些指标；columns指定竖列表示统计量还是变量，如果是变量，就改为columns(variables)，但这种呈现方式不易查看，不建议用
tabstat age qp101 qp102, statistic(mean sd) columns(statistics) by(gender) //by根据某变量分类来分类呈现，顺序从左到右-从上到下
tab gender, sum(age) //tab后面跟分类变量，sum里面写数值型变量，看各组别下某连续型变量的基本情况
hist qg11 //月工资，长尾分布
gen ln_income=ln(qg11) //没有让它作因变量参与回归，还是不要带入下面的列联表里面，以免不便于解读
hist ln_income //近似正态分布
tab party urban20, sum(qg11) //也可以做列联表，看各交叉分类之下，工资的基本情况，从上至下指标为均值、标准差、频数

** 正态分布检验
*图形
hist qg11, normal //作直方图出来，并绘制相应的曲线
hist ln_income, normal //可以初步根据其形状判断
qnorm qg11 //对比实际分位数和理论分位数，如果大致沿直线分布，则为正态
qnorm ln_income

*数值
sum qg11, de //通过查看偏度峰度数值来判断，偏度S与0比较 峰度K与3比较
sum ln_income, de
sktest ln_income //看p值 显著-偏度、峰度太大，联合检验p值显著，不服从正态分布
ladder qg11 //看如何转换才能变为正态，p值显著则此转换不行，如果为.则结果出错，同样不可以采用
ladder ln_income
