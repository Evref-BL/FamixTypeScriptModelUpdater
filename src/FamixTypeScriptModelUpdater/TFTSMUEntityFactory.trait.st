Trait {
	#name : 'TFTSMUEntityFactory',
	#instVars : [
		'famixModel',
		'fileAnchorPath',
		'fastModel',
		'newStartPosition',
		'newEndPosition'
	],
	#category : 'FamixTypeScriptModelUpdater-Updater',
	#package : 'FamixTypeScriptModelUpdater',
	#tag : 'Updater'
}

{ #category : 'model - create' }
TFTSMUEntityFactory >> create: aFamixClass [

	^ self famixModel add: aFamixClass new
]

{ #category : 'model - create' }
TFTSMUEntityFactory >> create: aFamixClass from: aFastTypeScriptEntity [

	| entity |
	entity := self create: aFamixClass.
	self fileAnchorPath ifNotNil: [ :famixSourceAnchor |
		entity sourceAnchor:
			(self generateAnchorBasedOn: famixSourceAnchor for: aFastTypeScriptEntity) ].
	^ entity
]

{ #category : 'accessing' }
TFTSMUEntityFactory >> famixModel [

	^ famixModel
]

{ #category : 'accessing' }
TFTSMUEntityFactory >> famixModel: anObject [

	famixModel := anObject
]

{ #category : 'accessing' }
TFTSMUEntityFactory >> fastModel [

	^ fastModel
]

{ #category : 'accessing' }
TFTSMUEntityFactory >> fastModel: anObject [

	fastModel := anObject
]

{ #category : 'accessing' }
TFTSMUEntityFactory >> fastScopeOwnerOf: aFASTJavaNode [

	^ (aFASTJavaNode atAnyScope: { 
			   FASTTypeScriptMethodDefinition . "Pay attention here perhaps function is also needed or any other;"
			   FASTTypeScriptClassDeclaration }) ifNotNil: [ :scopes | scopes anyOne ]
]

{ #category : 'accessing' }
TFTSMUEntityFactory >> fileAnchorPath [

	^ fileAnchorPath
]

{ #category : 'accessing' }
TFTSMUEntityFactory >> fileAnchorPath: anObject [

	fileAnchorPath := anObject
]

{ #category : 'model - create' }
TFTSMUEntityFactory >> generateAnchorBasedOn: famixSourceAnchor for: aFastTypeScriptEntity [

	| safeStart safeEnd|
	safeStart :=  self newStartPosition 
		ifNil: [ aFastTypeScriptEntity startPos ].
		
	safeEnd :=  self newEndPosition 
		ifNil: [ aFastTypeScriptEntity endPos ].

	^ (self create: FamixTypeScriptIndexedFileAnchor)
		  startPos: safeStart;
		  endPos: safeEnd;
		  fileName: famixSourceAnchor ;
		  yourself
]

{ #category : 'accessing' }
TFTSMUEntityFactory >> newEndPosition [

	^ newEndPosition
]

{ #category : 'accessing' }
TFTSMUEntityFactory >> newEndPosition: anObject [

	newEndPosition := anObject
]

{ #category : 'accessing' }
TFTSMUEntityFactory >> newStartPosition [

	^ newStartPosition
]

{ #category : 'accessing' }
TFTSMUEntityFactory >> newStartPosition: anObject [

	newStartPosition := anObject
]

{ #category : 'model - create' }
TFTSMUEntityFactory >> retrieveClassFromModel: aClassName [
self notYetImplemented .
	"^ (fastModel allWithType: FASTTypeScriptImportClause ) ""pay attention for java it was declaration and here there are many thing for import""
		  detect: [ :importDeclaration | 
			  importDeclaration declarationName name = aClassName ]
		  ifOne: [ :importDeclaration | 
			  self famixModel allPackages
				  detect: [ :pa | 
					  pa qualifiedName
					  = importDeclaration declarationName namespace fullName ]
				  ifOne: [ :package | 
					  package types
						  detect: [ :type | type name = aClassName ]
						  ifNone: [ nil ] ] ]
		  ifNone: [ 
			  self famixModel allModelTypes  asOrderedCollection
				  detect: [ :class | class name = aClassName ]
				  ifNone: [ nil ] ]"
]
