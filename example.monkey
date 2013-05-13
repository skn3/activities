Import skn3.activites

Global MY_ACTIVITY:= RegisterActivityId("My Activity")

Function Main:Int()
	AddActivityReciever(New Reciever1, MY_ACTIVITY)
	AddActivityReciever(New Reciever2, MY_ACTIVITY)
	AddActivityReciever(New Reciever3, MY_ACTIVITY)
	
	Repeat
	Until
End

Class Reciever1 Implements ActivityReciever
	Method OnActivity:Void(activity:Activity, started:Bool)
		If started
			
		EndIf
	End
End

Class Reciever2 Implements ActivityReciever
	Method OnActivity:Void(activity:Activity, started:Bool)
		If started
			
		EndIf
	End
End

Class Reciever3 Implements ActivityReciever
	Method OnActivity:Void(activity:Activity, started:Bool)
		If started
			
		EndIf
	End
End