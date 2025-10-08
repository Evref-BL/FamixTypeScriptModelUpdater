Class {
	#name : 'BaselineOfFamixTypeScriptModelUpdater',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfFamixTypeScriptModelUpdater',
	#package : 'BaselineOfFamixTypeScriptModelUpdater'
}

{ #category : 'baselines' }
BaselineOfFamixTypeScriptModelUpdater >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec description: 'This is FamixTypeScriptModelUpdater'.
			spec author: 'AlessHosry'.
			self defineDependencies: spec.
			self definePackages: spec.
			self defineGroups: spec ]
]

{ #category : 'accessing' }
BaselineOfFamixTypeScriptModelUpdater >> customProjectAttributes [

	^ PackageOrganizer default packages
		  detect: [ :package |
		  package name = 'BaselineOfFamixTypeScriptModelUpdater' ]
		  ifFound: [ #(  ) ]
		  ifNone: [ #( #NeedsMoose ) ]
]

{ #category : 'baselines' }
BaselineOfFamixTypeScriptModelUpdater >> defineDependencies: spec [

	spec baseline: 'CarrefourTypeScript' with: [ 
		spec
			loads: #( 'default' );
			repository: 'github://moosetechnology/Carrefour-TypeScript:main/src' ].
 
]

{ #category : 'baselines' }
BaselineOfFamixTypeScriptModelUpdater >> defineGroups: spec [

	spec
		group: 'core'
		with: #( 'FamixTypeScriptModelUpdater' ) 
]

{ #category : 'baselines' }
BaselineOfFamixTypeScriptModelUpdater >> definePackages: spec [

	spec
		package: 'FamixTypeScriptModelUpdater'
		with: [ spec requires: #( 'CarrefourTypeScript' ) ].

	"In case of no Famix loaded"
	spec for: #NeedsMoose do: [
			spec
				package: 'FamixTypeScriptModelUpdater'
				with: [ spec requires: #( 'CarrefourTypeScript') ] ]
]
