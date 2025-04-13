** 直方图
//虽然都是条状的，但是直方图和条形图是非常不同的数据呈现方式。条形图展示的是某变量在不同组别的频数分布情况，直接用高度表示频数；常用于分类变量。而直方图用长方形的面积表示频数，常用于连续型变量（但stata也能画分类变量的histogram）
histogram m_income //看一下月收入的直方图
histogram age, bin(10) width(5) //bin()设置条柱数量，width()设置柱子宽度，不能同时使用，否则报错，就像这条命令一样.报错：options bin() and width() may not be combined
histogram age, bin(10) gap(1.5) //gap()设置条柱之间的距离
histogram age, width(5)
histogram age, start(0) //设置横轴的起点，默认为最小值
hist educ, discrete //分类变量也可以作直方图，不过要说明一下
histogram m_income, density //按密度绘制柱高，这是默认的，可以不用说明
histogram m_income, fraction //按比例绘制
histogram m_income, frequency //按频数绘制
histogram m_income, percent //按百分比绘制
hist educ, percent discrete by(gender,total) start(0) width(2) normal xtitle("被访者最高受教育程度") xsize(4) ysize(3) //normal绘制一条基于样本均值和标准差正态分布密度曲线，xsize和ysize设置图表比例
count if !missing(educ, gender) //查看两者都不缺失的话，一共有多少观察值。这个方法由ChatGPT提供，我的提问方式为：“我做了某个特定的图表，比如年龄的直方图，分性别。那这个时候我怎么查看一共有多少观察值参与？因为年龄和性别的观察值个数不可能相同，总会有缺失”
local n = r(N) //临时保留一个变量
hist educ, percent by(hk) title("受教育年限的城乡分布") xtitle("受教育年限") ytitle("百分比") addlabel start(0) width(2) normal xtitle("被访者最高受教育程度") gap(3) note(Source:CFPS2018) title("年龄直方图（N = `n'）") //用这个方法可以在各组的表头显示有多少观察值参与，但是要三行代码一起运行
