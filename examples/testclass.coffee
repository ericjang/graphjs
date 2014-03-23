class Animal
    constructor : (data=null, attr={}) ->
        console.log data
        console.log attr
        console.log (data is null)


a = new Animal()
