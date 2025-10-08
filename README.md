# FamixTypeScriptModelUpdater
This project is similar to FamixJavaModelUpdater but for TypeScript.
The main task of it is to update Famix and FAST models following modifications.
 
## Installation

### From playground

```st
Metacello new 
  baseline: 'FamixTypeScriptModelUpdater';
  repository: 'github://Evref-BL/FamixTypeScriptModelUpdater:main/src';  
  load.
```

### Baseline dependency

```st
spec baseline: 'FamixTypeScriptModelUpdater' with: [ 
  spec repository: 'github://evref-bl/FamixTypeScriptModelUpdater:main/src' ].
```

## Usage

```st
FTSMUModelUpdater new
  famixModel: self mooseModel;
  fastModel: fast;
  famixEntity: famixEntity;
  update
```

## Developers

You can build the `output.json` using ts2famix documented here: https://fuhrmanator.github.io/posts/typescript-in-moose/index.html.

> 💡⚠️ **NB**  
> The project is still at the very beginning.  
> We keep updating it to meet our needs.  
> Your contributions are more than welcome!  
> **Enjoy **
