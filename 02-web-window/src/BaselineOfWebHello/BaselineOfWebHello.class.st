Class {
	#name : 'BaselineOfWebHello',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfWebHello',
	#package : 'BaselineOfWebHello'
}

{ #category : 'baselines' }
BaselineOfWebHello >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: 'WebHello' ]
]
