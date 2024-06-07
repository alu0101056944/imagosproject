# Bone age estimator 

A program that reads a Domain Specific Language (DSL) file with a target radiography description (bone measurements) to be compared against a reference atlas of age labeled radiographies. Closest match to target results in it's labeled age being the final estimated age.

# How to use

## 1.- Install dependencies

Install Ruby (tested with v3.3) and then execute:

```bash
bundle install
```

## 2.- Write the DSL file.


## 3.- Execute the program

There is a [bin/boneage](bin/boneage) program that reads that file.

### Get the age estimation

Execute:

```bash
bin/boneage execute PATH
```

For example, for this instruction file:

```
COMPARE THE RADIOGRAPHY OBSERVED BY Juan
  USING THE simpleatlas ATLAS
  STARTING WITH GENDER male
  DEFINED BY
  A Radius BONE OF MEASUREMENTS
  length = 3

```

And given this atlas:

```
DEFINE A greulichPyle ATLAS NAMED mygreulichpyleatlas
  WITH THE FOLLOWING RADIOGRAPHIES
    ONE FOR GENDER male AGE 8 WITH
    A Radius BONE OF MEASUREMENTS
    length = 2.813

    ONE FOR GENDER male AGE 9 WITH
    A Radius BONE OF MEASUREMENTS
    length = 2.9

```

When executing it:

```bash
bin/boneage execute ./examples/new_sintax_atlas_example.ae
```

The output is:

![docs/estimation_result.png](docs/estimation_result.png)

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
