clear
use "路径\CFPS2018个人库_duplication.dta" //特别说明：使用的数据库为CFPS2018，详情参见官网

*** 林宗弘、吴晓刚（2010）文章复现过程
** 数据清洗
keep age gender cfps2018eduy_im qa301 qg2 jobclass_base qg14 egc1011 qg303code_isei qg303code_egp //保留之后我们要用到的变量
* 检查变量的缺失情况和值标签，看是否有需要清理的
tab age 
tab age, nol
recode age(-8=.)
tab gender
tab gender,nol
tab cfps2018eduy_im
tab qa301 
tab qa301,nol
recode qa301(-8 -1 79 5=.)
tab qg2
tab qg2,nol
recode qg2(-9 -8 -1 9 77=.)
tab jobclass_base
tab jobclass_base,nol
recode jobclass_base(-9 -8=.)
tab qg14
tab qg14,nol
recode qg14(-9 -8 -2 -1=.)
tab egc1011 
tab egc1011, nol
recode egc1011(-9 -8 -1=.)
tab qg303code_isei
tab qg303code_isei,nol
recode qg303code_isei(-9 -8=.)
tab qg303code_egp
tab qg303code_egp,nol
recode qg303code_egp(-9 -8=.)

* 修改变量标签以及值标签
label variable gender "性别" //原变量标签为“加载变量：受访者性别”
rename cfps2018eduy_im educy
label variable educy "受教育年限" //原为“CFPS2018个人问卷受访者已完成的受教育年限（插补）”
rename qa301 hk
label variable hk "户口性质" //原“现在的户口状况”
describe hk
label drop qa301 //解绑先前的值标签映射，因为要修改取值
recode hk(3=0)
label define hklabel 1 "农业户口" 0 "非农户口"
label values hk hklabel
tab hk
gen unit=.
replace unit=1 if qg2==1 | qg2==2 | qg2==3
replace unit=2 if qg2==8
replace unit=3 if qg2==4 | qg2==5 | qg2==7
label variable unit "单位性质"
label define unitlabel 1 "国有单位" 2 "集体单位" 3 "私有部门" //定义一个值标签映射集
label values unit unitlabel //把集合里面的标签附在变量取值上面
tab unit //看一下贴标签后的情况，合格
rename qg14 adm //不需修改变量标签，原为“是否有行政/管理职务”
rename egc1011 m_inc 
label variable m_inc "2016年-月收入（税后）" //原“2016年工作的每月税后收入（元/月）”
rename qg303code_isei ISEI //不需修改变量标签，原为“QG303职业威望：ISEI Code”
rename qg303code_egp EGP //不需修改变量标签，原为“QG303职业威望：EGP”
label define EGPlabel 1 "高级管理者" 2 "低级管理者" 3 "常规非体力雇员" 4 "小雇主" 5 "自雇佣者" 7 "体力雇员监工" 8 "熟练技术体力工人" 9 "半技术和无技术体力工人" 10 "农业劳动者" 11 "自耕农" //根据技术报告CFPS-10赋值
label values EGP EGPlabel
tab EGP
gen cap_level=.
label variable cap_level "收入-精英"
centile m_inc, centile(99) //看一下月税后收入的第1%位是多少
replace cap_level=1 if m_inc>=10000 & m_inc !=.
replace cap_level=0 if m_inc<10000 & m_inc !=.
label define cap_levellabel 1 "是" 0 "否"
label values cap_level cap_levellabel
tab cap_level
gen LW=.
replace LW=1 if hk==1 & jobclass_base==1 //农民
replace LW=2 if hk==1 & unit==2 & adm==1 //农村干部
replace LW=3 if hk==0 & unit==2 & adm==0 //集体单位工人
replace LW=4 if hk==0 & unit==2 & adm==1 //集体单位干部
replace LW=5 if hk==0 & unit==1 & adm==0 //国有单位工人
replace LW=6 if hk==0 & unit==1 & adm==1 //国有单位干部
replace LW=7 if unit==3 & adm==0
replace LW=8 if unit==3 & adm==1
replace LW=9 if jobclass_base==2 & cap_level==0
replace LW=10 if jobclass_base==2 & cap_level==1
label variable LW "林、吴的新马阶层分析"
label define LWlabel 1 "农民" 2 "农村干部" 3 "集体单位工人" 4 "集体单位干部"5 "国有单位工人" 6 "国有单位干部" 7 "无产阶级" 8 "新中产阶级" 9 "小资产阶级" 10 "资本家"
label values LW LWlabel
tab LW //数据清洗完成。之后记得要保存一下 save "路径\CFPS2018个人库_duplication.dta", replace


*** 复现第一部分：描述性统计
** 通过分组计算看各阶级的平均月税后收入和平均教育年限
* 计算每阶层的教育、收入平均值
bysort LW: sum educy
bysort LW: sum m_inc
bysort EGP: sum educy
bysort EGP: sum m_inc
* 计算每个组的标准误
keep if !missing(educy, LW, EGP, m_inc) //经过chatgpt提示，这样能够保持样本量一致，但会带来数据损失
bysort LW: egen educy_lwsd = sd(educy) if educy!=. & LW!=. // 计算每组的标准差
bysort LW: egen edulw_n = count(educy) if educy!=. & LW!=.     // 计算每组的样本量
gen educy_lwse = educy_lwsd / sqrt(edulw_n)     // 计算每组的标准误
label variable educy_lwse "林吴标准下的各阶层受教育年限标准误"
bysort EGP: egen educy_egpsd = sd(educy) if educy!=. & EGP!=.
bysort EGP: egen eduegp_n = count(educy)     if educy!=. & EGP!=.
gen educy_egpse = educy_egpsd / sqrt(eduegp_n)   
label variable educy_egpse "EGP下的各阶层受教育年限标准误"
bysort LW: egen minc_lwsd = sd(m_inc)  if m_inc!=. & LW!=.
bysort LW: egen minclw_n = count(m_inc)      if m_inc!=. & LW!=.
gen minc_lwse = minc_lwsd / sqrt(minclw_n)  
label variable minc_lwse "林吴标准下的各阶层月税后收入标准误"
bysort EGP: egen minc_egpsd = sd(m_inc)  if m_inc!=. & EGP!=.
bysort EGP: egen mincegp_n = count(m_inc)  if m_inc!=. & EGP!=.  
gen minc_egpse = minc_egpsd / sqrt(mincegp_n)     
label variable minc_egpse "EGP下的各阶层月税后收入标准误"
tab1 educy_lwse educy_egpse minc_lwse minc_egpse //查看频数、占比分布

* 简单方差分析
gen ln_minc=ln(m_inc)
label variable ln_minc "月税后收入对数"
anova educy LW
anova educy EGP
anova ln_minc LW
anova ln_minc EGP
