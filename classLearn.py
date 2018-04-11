class Snake:
    def __init__(self,name):
        self.name = name
    def change_name(self,new_name):
        self.name = new_name
snake=Snake('ant')
snakea=Snake('meyav')
print snake.name
print snakea.name


###Global & Loval 
global x
x=10
def func():
   #x =20
    print x
func()
print x

### arbitary function
def greet(*names):
    for name in names:
        print name

greet('sandy','pallu')

###recursive function
def recu():
    print "My memory dead"
    return (recu())
#recu()


#####Lambda
multiply = lambda x,y : x*y

print multiply(10,10)

##### Filter()
myList = [7,6,5,4,3]
newlist = list(filter(lambda x: (x%2 == 1),myList))
print newlist

#######map()
myList = [7,6,5,4,3]
newlist = list(map(lambda x: x*2,myList))
print newlist
