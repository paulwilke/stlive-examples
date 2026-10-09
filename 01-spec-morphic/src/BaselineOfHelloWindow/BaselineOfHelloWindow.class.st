Class {
	#name : 'BaselineOfHelloWindow',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfHelloWindow',
	#package : 'BaselineOfHelloWindow'
}

{ #category : 'baselines' }
BaselineOfHelloWindow >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'HelloWindow' ]
]
