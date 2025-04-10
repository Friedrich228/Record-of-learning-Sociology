** 散点图 使用数据：处理后的CFPS2018，详见
*基本知识点：y被假定为因变量，最好是数值型；x为自变量，可以是数值型或种类较多的分类变量
graph twoway scatter m_income educ //以收入和教育年限为例，这三条命令画出来的图是一样的
twoway scatter m_income educ
scatter m_income educ
scatter m_income educ, ytitle("最高教育年限") xtitle("月收入") title("月收入与被访者最高教育年限之间的关系") //可以设定图表标题、x与y轴的名称
scatter m_income educ, xlabel(#6) //最后图表在某个轴显示几个等分的刻度，这里就是在x轴教育年限显示6个等分刻度。如果不设置，stata默认提供5个
scatter m_income educ, xlabel(0(3)23) //甚至可以更灵活，指定起止点和间隔 起点数值(间隔值)终点值
scatter m_income educ, scheme(economist) //这个选项会让图表更美观、占用内存更小
scatter m_income educ, xlabel(,nogrid) ylabel(,grid) //可以自定义添加网格线，nogrid代表取消这个轴的网格线，grid代表添加上去
scatter m_income educ, xline(15) ylabel(10000) //强调某个点，这里选取的是教育年限为15年，月平均收入为1w的样本
scatter m_income educ, xaxis(1) || scatter m_income age, xaxis(2) ||, scheme(economist) title("教育年限和年龄分别对月收入的影响") // 可以同时使用x轴或y轴，比如对比教育和年龄对收入的影响，就要设置x轴；||代表区分数轴
scatter m_income educ, by(gender)
scatter m_income educ, mcolor(green) msize(2) msymbol(oh) xtitle("教育年限") ytitle("月工资") //mcolor定义散点的颜色，msize定义散点的大小，ms（简写）定义散点的形状
egen minc_m=mean(m_income) if gender==1, by(educ) //创建分教育年限的男性月均收入
label variable minc_m "分教育年限的男性月平均收入"
egen minc_f=mean(m_income) if gender==0, by(educ) //创建分教育年限的女性月均收入
label variable minc_f "分教育年限的女性月平均收入"
scatter minc_m educ, ms(oh) msize(3) mcolor(blue) || scatter minc_f educ, ms(oh) msize(3) mcolor(red) legend(position(11) ring(0))  ytitle("分教育年限的月均收入") xtitle("教育年限") title("分教育年限的两性月平均收入对比") //一次性画多个散点图，用||隔开，每一条命令都可以有自己的options；legend代表解释图例，position代表把它放在几点钟方向，ring(0)的意思是说把图例放在图表里面，没有这个的话就是放在外面的