
# Changelog

init project to ability platform

#1.2.8
修复安卓和ios多个map之间的跳转时，前一个页面的mark点击失效问题
#1.2.8
添加了 onMoveComplete函数，onMoveComplete 与 onChange只能二选一, onMoveComplete在移动地图的时候中心点变了都会调用

# 1.3.0
添加了 onMovingChange 回调函数

#2.0.0
集成github比较好的mapview组件，修复了一些bug
https://github.com/qiuxiang/react-native-amap3d

#2.0.1
重命名一些文件的名称，修复了ios的一些bug

#2.0.2-amap2d
  s.dependency 'React'


#2.0.2-amap2d.3
  web端的定位 AMap变量改为 window.AMap

#2.0.2-amap2d.4
  中心点偶然会偏移


#2.0.2-amap2d.5
  fetchLocation 错误信息安卓支持  if(error) 判断