#simple update function
update = (object, attr) ->
  for key,val of attr
    object[key] = val

#deep copy function written in coffeescript!
clone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj

  if obj instanceof Date
    return new Date(obj.getTime())

  if obj instanceof RegExp
    flags = ''
    flags += 'g' if obj.global?
    flags += 'i' if obj.ignoreCase?
    flags += 'm' if obj.multiline?
    flags += 'y' if obj.sticky?
    return new RegExp(obj.source, flags)

  newInstance = new obj.constructor()

  for key of obj
    newInstance[key] = clone obj[key]

  return newInstance


#check if type is array
typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

#python-like items() function, except no such thing as tuples

_items = (dict) -> return ([key,val] for key,val of dict)

#array sum function
_sum = (nums) -> nums.reduce (a,b) -> a+b


#list function for converting iterable containers into an array
_list = (iterable) ->
  if typeIsArray iterable
    return iterable
  else
    #must be object?
    return Object.getOwnPropertyNames iterable

#Mixins function - adds anything that is not already a property of the class
#therefore, order in which mixins are applied is important
mix = (class, mixin) ->
  for name, method of mixin
    if name not of class
      class[name] = method