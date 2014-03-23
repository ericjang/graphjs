# TODO if you end up needing too many helper functions
# use some lodash

exports.get = (obj, key, _default) ->
  if key of obj
    obj[key]
  else
    _default

#simple update function
exports.extend = (out) ->
  out = out or {}
  i = 1
  while i < arguments.length
    continue  unless arguments[i]
    for key of arguments[i]
      out[key] = arguments[i][key]  if arguments[i].hasOwnProperty(key)
    i++
  out

# sugar function
exports.update = exports.extend
exports.merge = exports.extend

# delete a key in obj
exports.del = (obj, key) ->
  delete obj[key]

exports.keys = (obj) ->
  (key for own key, val of obj)

exports.values = (obj) ->
  (val for own key, val of obj)

exports.items = (obj) ->
  # bar = {'1':2,'ass':1}
  # items(bar) = [['1',2],['ass',1]]
  ([key,val] for own key, val of obj)

# hail Douglas Crockford
exports.typeIsArray = ( value ) ->
    value and
        typeof value is 'object' and
        value instanceof Array and
        typeof value.length is 'number' and
        typeof value.splice is 'function' and
        not ( value.propertyIsEnumerable 'length' )

exports.len = (obj) ->
  if exports.typeIsArray(obj)
    obj.length
  else
    exports.keys(obj).length


# deepcopy
exports.clone = (obj) ->
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

exports.deepcopy = exports.clone

# coffeescript mixins
# http://coffeescriptcookbook.com/chapters/classes_and_objects/mixins
exports.mixOf = (base, mixins...) ->
  class Mixed extends base
  for mixin in mixins by -1 #earlier mixins override later ones
    for name, method of mixin::
      Mixed::[name] = method
  Mixed

exports.zip = () ->
  lengthArray = (arr.length for arr in arguments)
  length = Math.min(lengthArray...)
  for i in [0...length]
    arr[i] for arr in arguments


# #check if type is array
# typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'

# #python-like items() function, except no such thing as tuples

# _items = (dict) -> return ([key,val] for key,val of dict)

# #array sum function
# _sum = (nums) -> nums.reduce (a,b) -> a+b


# #list function for converting iterable containers into an array
# _list = (iterable) ->
#   if typeIsArray iterable
#     return iterable
#   else
#     #must be object?
#     return Object.getOwnPropertyNames iterable




