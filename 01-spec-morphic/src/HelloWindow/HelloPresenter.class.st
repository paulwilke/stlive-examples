"
A small window with a button
"
Class {
	#name : 'HelloPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'label',
		'button',
		'count'
	],
	#package : 'HelloWindow'
}

{ #category : 'actions' }
HelloPresenter >> click [
	count := count + 1.
	label label: 'Hallo aus Smalltalk! Klicks: ', count printString
]

{ #category : 'accessing' }
HelloPresenter >> count [
	^ count
]

{ #category : 'initialization' }
HelloPresenter >> initializePresenters [
	count := 0.
	label := self newLabel label: 'Noch nicht geklickt'.
	button := self newButton label: 'Klick mich!'; action: [ self click ]; yourself.
	self layout: (SpBoxLayout newTopToBottom spacing: 10; borderWidth: 15; add: label; add: button expand: false; yourself)
]

{ #category : 'initialization' }
HelloPresenter >> initializeWindow: aWindow [
	aWindow title: 'Hello Window'; initialExtent: 320@120
]
