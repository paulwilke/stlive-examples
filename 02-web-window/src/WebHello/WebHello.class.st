"
HTTP UI: a Zinc server inside the image; HTML/CSS shown in a window outside of Pharo
"
Class {
	#name : 'WebHello',
	#superclass : 'Object',
	#instVars : [
		'server',
		'count'
	],
	#classInstVars : [
		'default'
	],
	#package : 'WebHello'
}

{ #category : 'control' }
WebHello class >> start: aPort [
	default ifNotNil: [ default stop ].
	^ default := self new start: aPort; yourself
]

{ #category : 'http' }
WebHello >> handle: request [
	request uri path = 'api/click' ifTrue: [
		count := count + 1.
		^ ZnResponse ok: (ZnEntity json: '{"count":', count printString, ',"message":"Hello from Smalltalk!"}') ].
	^ ZnResponse ok: (ZnEntity html: self page)
]

{ #category : 'http' }
WebHello >> page [
	^ '<!doctype html><meta charset=utf-8><title>Hello Web Window</title>
<style>
:root{color-scheme:light dark;font:16px system-ui,-apple-system,"Segoe UI",sans-serif}
body{margin:0;height:100vh;display:grid;place-items:center;background:linear-gradient(135deg,#6366f1,#ec4899);}
main{background:rgba(255,255,255,.85);backdrop-filter:blur(20px);color:#111;padding:1.5rem 2rem;border-radius:20px;box-shadow:0 20px 60px #0004;text-align:center}
h1{margin:0 0 .8rem;font-size:1.5rem}button{font:inherit;font-weight:600;padding:.8rem 1.6rem;border:0;border-radius:12px;background:#059669;color:#fff;cursor:pointer;transition:.15s}
button:hover{transform:translateY(-2px);box-shadow:0 8px 20px #05966966}button:active{transform:none}
</style>
<main><h1 id=m>Not clicked yet</h1><button onclick="go()">Click me!</button></main>
<script>async function go(){const r=await (await fetch("/api/click")).json();m.textContent=r.message+" Clicks: "+r.count}</script>'
]

{ #category : 'control' }
WebHello >> start: aPort [
	count := 0.
	server := ZnServer on: aPort.
	server onRequestRespond: [ :req | self handle: req ].
	server start
]

{ #category : 'control' }
WebHello >> stop [
	server ifNotNil: [ server stop ]
]
