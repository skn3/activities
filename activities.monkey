Strict

Import monkey.list
import monkey.stack

'globals
Private
Global activityIdCount:Int
Global activityIds:= New ArrayList<String>
Global recieverIdLists:= New IntMap<ArrayList<ActivityReciever>>
Public

'public interface
Interface ActivityReciever
	Method OnActivity:Void(activity:Activity, started:Bool)
End

'classes
Class ActivityQueue
	Global pool:= New Stack<Activity>

	'api
	Method StartActivity:Void(id:Int, data:Object)
		' --- this will start an activity ---
		'let all all listening recievers know that an activity is starting
		Local list:= recieverIdLists.ValueForKey(id)
		If list
			'get new activity
			Local activity:Activity
			If pool.IsEmpty()
				'create new activity
				activity = New Activity
			Else
				'reuse old activity
				activity = pool.Pop()
			EndIf
			
			'setup activity
			activity.alive = True
			activity.queue = Self
			activity.id = id
			activity.data = data
		
			'let all activity recievers know an activity is starting
			For Local index:= 0 Until list.count
				list.data[index].OnActivity(activity, True)
			Next
			
			'f check iactivity has finished
			If activity.IsActive() = False
				EndActivity(activity)
				activity = Null
			EndIf
		EndIf
	End
	
	Method StartActivity:Void(id:Int)
		' --- shortcut ---
		StartActivity(id, Null)
	End
	
	Method StartActivity:Void(id:Int, data:Bool)
		' --- shortcut ---
		StartActivity(id, Object(BoolObject(data)))
	End

	Method StartActivity:Void(id:Int, data:int)
		' --- shortcut ---
		StartActivity(id, Object(IntObject(data)))
	End
	
	Method StartActivity:Void(id:Int, data:float)
		' --- shortcut ---
		StartActivity(id, Object(FloatObject(data)))
	End
	
	Method StartActivity:Void(id:Int, data:string)
		' --- shortcut ---
		StartActivity(id, Object(StringObject(data)))
	End
	
	Method EndActivity:Void(activity:Activity)
		' --- end an activity ---
		'inform activity recievers
		Local list:= recieverIdLists.ValueForKey(activity.id)
		If list
			For Local index:= 0 Until list.count
				list.data[index].OnActivity(activity, False)
			Next
		EndIf
		
		'cleanup
		activity.alive = False
		activity.id = 0
		activity.refCount = 0
		activity.queue = Null
		activity.data = Null
		
		'add to dead pool
		pool.Push(activity)
	End
End

Class Activity
	Private
	Field queue:ActivityQueue
	Field refCount:Int
	Public
	Field alive:Bool
	Field id:Int
	Field data:Object
	
	'api
	Method IsActive:Bool()
		' --- return true if the activity is being used ---
		Return alive and refCount > 0
	End
	
	Method Join:Void()
		' --- join the activity ---
		If alive = False Return
		refCount += 1
	End
	
	Method Leave:Void()
		' --- leave teh activity ---
		If alive = False Return
		
		'decrease reference to activity
		refCount -= 1
		
		'check to see if we are ending
		If refCount = 0 queue.EndActivity(Self)
	End
End

'api
Function RegisterActivityId:Int(name:string)
	' --- register a uniquee activity id ---
	'create new id
	activityIdCount += 1
	
	'set the activity id name
	activityIds.AddLast(name)
	
	'return id of activity
	Return activityIdCount
End

Function RemoveActivityReciever:Void(reciever:ActivityReciever)
	' --- remove a activity reciever ---
	Local list:ArrayList<ActivityReciever>
	For Local listId:= EachIn recieverIdLists.Keys()
		list = recieverIdLists.ValueForKey(listId)
		If list
			'remove reciever from list
			list.Remove(reciever)
			
			'check for empty list
			If list.IsEmpty() recieverIdLists.Remove(listId)
		EndIf
	Next
End

Function AddActivitykReciever:Void(reciever:ActivityReciever, id:int)
	' --- add a activity reciever ---
	If id = 0 Return
	
	'see if the list exists
	Local list:= recieverIdLists.ValueForKey(id)
	If list = Null
		'create new list
		list = New ArrayList<ActivityReciever>
		recieverIdLists.Insert(id, list)
	EndIf
	
	'add reciever to list
	If list.Contains(reciever) = False list.AddLast(reciever)
End