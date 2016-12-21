from lxml import etree
from StringIO import StringIO
import sys
import argparse

# Removes duplicates and then the first path
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Clean p5 generated svg')
    parser.add_argument("-i", "--input", help="in svg file name")
    parser.add_argument("-o", "--out", help="out svg file name")

    parser.set_defaults(input="out.svg", output="res.svg")
    args = parser.parse_args()
    inFile = args.input
    outFile = args.out

    print("infile is " + inFile)
    print("outfile is " + outFile)

    tree = etree.parse(open(inFile, 'r'))

    root = tree.getroot()
    # Use a `set` to keep track of "visited" elements with good lookup time.
    visited = set()

    # The iter method does a recursive traversal
    for el in root.iter("{http://www.w3.org/2000/svg}path"):
        #print("iter")
        # Since the d is what defines a duplicate for you
        if 'd' in el.attrib:
            current = el.get('d')
            # In visited already means it's a duplicate, remove it
            if current in visited:
                el.getparent().remove(el)

            # Otherwise mark this ID as "visited"
            else:
                visited.add(current)

    for el in root.iter("{http://www.w3.org/2000/svg}path"):
        el.getparent().remove(el)
        break

    for el in root.iter("{http://www.w3.org/2000/svg}g"):
        if not len(list(el)):
            el.getparent().remove(el)

    # TODO maybe clean empty elements
    with open(outFile, 'w') as f:
        print("write")
        tree.write(f, pretty_print=True)