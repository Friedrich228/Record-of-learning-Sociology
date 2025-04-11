** 线图
//适用于数值型和连续型的时间序列数据
graph twoway line height age //三个命令的效果是一样的，但是线条很爆炸，后文会讲怎么处理
twoway line height age
line height age
sort age //将x排序之后，看看能否解决这个问题
line height age //每个age对应了太多的m_income，应当用均值去代替
egen m_height=mean(height), by(age) //所以要创建各年龄对应的平均身高，这样才好作线图
line m_height age //效果不错。一般来说，我们是比较关注青少年群体的年龄与身高之间的关系的，这里只是用全年龄段作演示案例。
egen m_weight=mean(weight), by(age)
label variable m_height "年龄身高均值（厘米）"
label variable m_weight "年龄体重均值（斤）"
egen m_edu=mean(educ), by(age)
label variable m_edu "年龄教育年限均值（年）"
line m_height age || line m_weight age || line m_edu age if m_edu!=. ,yaxis(2) legend(row(3) position(12)) ytitle("身高或体重") ytitle("年龄教育年限均值", axis(2)) scheme(economist) //需要着重解释一下第二个||之后的命令：作平均教育年限和年龄的线图，教育年限均值为有效数值，使用第二个y轴。图例分为三排，在12点钟方向，放在图外面。命名y轴，第一个不用点明，默认左边；第二个要标注出来，axis(2) scheme可有可无，看要什么样美观的图表
graph twoway line m_height age || line m_weight age || line m_edu age if m_edu!=. , yaxis(2) legend(row(3) position(6) ring(0)) ytitle("身高或体重") ytitle("年龄教育年限均值", axis(2)) lcolor(green blue purple) lwidth(0.2 0.2 0.2) connect(line stairsteps line) clpattern(longdash solid dash) //可以在后面自定义线条颜色、粗细、联结方式、格式等。line代表普通线条，stairsteps代表台阶式线条，longdash是断续的长线，solid是连续线条，dash为不连续短线
graph twoway line m_height m_weight m_edu age if m_edu!=. , yaxis(2) legend(row(3) position(12)) lcolor(green blue purple) lwidth(0.2 0.2 0.2) connect(line stairsteps line) clpattern(longdash solid dash) //命令可以整合起来，不去设置各自的y轴，这样它们是被放在同一个测量尺度之下的
graph twoway bar m_height m_weight m_edu age if m_edu!=. , yaxis(2) legend(row(3) position(12)) lcolor(green blue purple) lwidth(0.5 0.5 0.5) //还可以换为条形图
graph twoway area m_height m_weight m_edu age if m_edu!=. , yaxis(2) legend(row(3) position(12)) lcolor(green blue purple) //面积图
graph twoway scatter m_height m_weight m_edu age if m_edu!=. , yaxis(2) legend(row(3) position(12)) lcolor(green blue purple) //散点图
graph twoway dot m_height m_weight m_edu age if m_edu!=. , yaxis(2) legend(row(3) position(12)) lcolor(green blue purple) //点图
//小结：作图命令的许多语法都是相通的，关键要搞清楚自己想看哪些变量之间的关系，多写多练，就能跑出来。