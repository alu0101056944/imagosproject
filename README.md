# Ruby gem for Bone Age Estimation DSL

alu0101056944

Marcos Jesús Barrios Lorenzo

## Description

Domain Specific Languages are a good way to make more explicit the process of bone age estimation. This program can be used to setup bone measurements that are compared to an atlas's measurements to obtain an age estimation. The main objective is to offer an open system as opposed to black box alternatives for the Greulich Pyle, Tanner-Whitehouse methods for bone age estimation.

## Requirements

 - Ruby (3.3 tested)

## Installation

To install, execute the following CLI command:

```console
bundle install
```

or use the [bin/setup](bin/setup) executable:

```console
./bin/setup
```

## Usage

Use the [bin/boneage](bin/boneage) executable, pass as parameter the path to the DSL file to be executed:

```console
./bin/boneage execute ./examples/basic_example.rb 
```

**The path must be relative, `examples/basic_example.rb` does not work, while `./examples/basic_example.rb` does**.

This is what happens when the path parameter is not included:

```bash
usuario@ubuntu ~/ruby/imagosproject (dev) $ ./bin/boneage execute 
ERROR: "boneage execute" was called with no arguments
Usage: "boneage execute PATH"
```
