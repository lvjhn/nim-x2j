import os, streams, strutils, sequtils
import parsexml as xml
import json

var is_debugging = true

proc debug(str : string)  =
    if is_debugging: 
        echo str

proc repeat(str : string, reps : int) : string = 
    var str_copy : string = ""
    for i in 0..reps: 
        str_copy &= str
    result = str_copy

proc xmlFileToJson(filename : string) : JsonNode = 
    var stream = newFileStream(filename, fmRead) 
    var json_obj = newJObject() 

    json_obj["attrs"] = newJObject() 
    json_obj["children"] = newJObject() 

    var stack : seq[string] = @[]
    var indent : int = 0

    # references to the base objects
    var base_stack = @[json_obj]

    # return an error if the file cannot be found
    if stream == nil: 
        debug ("xml-to-json : The file " & $filename & " cannot be found.")
        result = nil    
    else: 
        var xml_parser = xml.XmlParser() 
        xml_parser.open(stream, filename) 

        while true: 
            let kind = xml_parser.kind

            debug "\t".repeat(indent - 1) & $kind
            if kind == xmlEof: 
                debug ("End of file reached, stopping procedure.")
                break 
            elif kind == xmlElementStart or kind == xmlElementOpen:
                let element_name = xml_parser.elementName
                debug ("\t".repeat(indent - 1) & element_name)
                stack.add(element_name)

                var base = newJObject()
                base["attrs"] = newJObject() 
                base["children"] = newJObject() 

                var ref_base = base_stack[^1]
                ref_base["children"][element_name] = base 
                base_stack.add(ref_base["children"][element_name])


                debug ("\t".repeat(indent - 1) & $stack)
                indent += 1 
                debug("")
            elif kind ==  xmlElementEnd:
                debug ("\t".repeat(indent - 1) & $stack)
                discard stack.pop()
                discard base_stack.pop()   
                debug ("\t".repeat(indent - 1) & $stack)
                indent -= 1 
                debug("")
            elif kind ==  xmlCharData:
                debug ("\t".repeat(indent - 1) & $stack)
                let value = xml_parser.charData()
                base_stack[^1]["attrs"]["char-data"] = newJString(value)
                debug("")
            elif kind == xmlAttribute: 
                let indent : string = "\t".repeat(indent - 1) & "@attr "
                let key = xml_parser.attrKey()
                let value = xml_parser.attrValue()
                debug (indent & key & "=" & value)
                base_stack[^1]["attrs"][key] = newJString(value)
                debug("")
            else: 
                discard 

            xml_parser.next()
    result = json_obj

export 
    xmlFileToJson,
    repeat,
    is_debugging
