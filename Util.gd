# import with 
# const Util = preload('res://Util.gd')

static func array_str(l:Array):
	return "['%s']" % join(l, "', '")


static func join(l:Array, j:String=','):
	if len(l) == 0: 
		return ''
	var s:String = ''
	for k in range(0,len(l)-1):
		s += '%s%s' % [l[k], j]
	return s + l[len(l)-1]

