package kha.internal;

import haxe.Json;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import haxe.Serializer;
import sys.io.File;

using StringTools;

class ShadersBuilder {

	public static function findResources(): String {
		#if macro
		var output = Compiler.getOutput();
		if (output == "Nothing__" || output == "") { // For Haxe background compilation
			#if kha_output
			output = Compiler.getDefine("kha_output");
			if (output.startsWith('"')) {
				output = output.substr(1, output.length - 2);
			}
			#end
		}
		output = output.replace("\\", "/");
		output = output.substring(0, output.lastIndexOf("/"));
		if (output.endsWith("/Assets")) { // For Unity
			output = output.substring(0, output.lastIndexOf("/"));
		}
		if (output.lastIndexOf("/") >= 0) {
			var system = output.substring(output.lastIndexOf("/") + 1);
			if (system.endsWith("-build")) system = system.substr(0, system.length - "-build".length);
			output = output.substring(0, output.lastIndexOf("/"));
			return output + "/" + system + "-resources/";
		}
		else {
			if (output.endsWith("-build")) output = output.substr(0, output.length - "-build".length);
			if (output == "") output = "empty";
			return output + "-resources/";
		}
		#else
		return "";
		#end
	}

	macro static public function build(): Array<Field> {
		var fields = Context.getBuildFields();
		
		var content = Json.parse(File.getContent(findResources() + "files.json"));
		var files: Iterable<Dynamic> = content.files;
		
		var init = macro { };
		
		for (file in files) {
			var name: String = file.name;
			var fixedName: String = name;
			var dataName = fixedName + "Data";
			var filenames: Array<String> = file.files;
			
			if (file.type == "shader") {
				var serialized: Array<String> = [];
				for (filename in filenames) {
					serialized.push(Serializer.run(File.getBytes(findResources() + filename)));
				}
				for (i in 0...filenames.length) {
					fields.push({
						name: dataName + i,
						doc: null,
						meta: [],
						access: [APrivate, AStatic],
						kind: FVar(macro: String, macro $v { serialized[i] } ),
						pos: Context.currentPos()
					});
				}
				
				if (name.endsWith("_comp")) {
					fields.push({
						name: fixedName,
						doc: null,
						meta: [],
						access: [APublic, AStatic],
						kind: FVar(macro: kha.compute.Shader, macro null),
						pos: Context.currentPos()
					});
					
					init = macro {
						$init;
						{
							var blobs = new Array<Blob>();
							for (i in 0...$v{filenames.length}) {
								var data = Reflect.field(Shaders, $v { dataName } + i);
								var bytes: haxe.io.Bytes = haxe.Unserializer.run(data);
								blobs.push(kha.Blob.fromBytes(bytes));
							}
							$i { fixedName } = new kha.compute.Shader(blobs, $v { filenames });
						}
					};
				}
				else if (name.endsWith("_geom")) {
					fields.push({
						name: fixedName,
						doc: null,
						meta: [],
						access: [APublic, AStatic],
						kind: FVar(macro: kha.graphics4.GeometryShader, macro null),
						pos: Context.currentPos()
					});
					
					init = macro {
						$init;
						{
							var blobs = new Array<Blob>();
							for (i in 0...$v{filenames.length}) {
								var data = Reflect.field(Shaders, $v { dataName } + i);
								var bytes: haxe.io.Bytes = haxe.Unserializer.run(data);
								blobs.push(kha.Blob.fromBytes(bytes));
							}
							$i { fixedName } = new kha.graphics4.GeometryShader(blobs, $v { filenames });
						}
					};
				}
				else if (name.endsWith("_tesc")) {
					fields.push({
						name: fixedName,
						doc: null,
						meta: [],
						access: [APublic, AStatic],
						kind: FVar(macro: kha.graphics4.TessellationControlShader, macro null),
						pos: Context.currentPos()
					});
					
					init = macro {
						$init;
						{
							var blobs = new Array<Blob>();
							for (i in 0...$v{filenames.length}) {
								var data = Reflect.field(Shaders, $v { dataName } + i);
								var bytes: haxe.io.Bytes = haxe.Unserializer.run(data);
								blobs.push(kha.Blob.fromBytes(bytes));
							}
							$i { fixedName } = new kha.graphics4.TessellationControlShader(blobs, $v { filenames });
						}
					};
				}
				else if (name.endsWith("_tese")) {
					fields.push({
						name: fixedName,
						doc: null,
						meta: [],
						access: [APublic, AStatic],
						kind: FVar(macro: kha.graphics4.TessellationEvaluationShader, macro null),
						pos: Context.currentPos()
					});
					
					init = macro {
						$init;
						{
							var blobs = new Array<Blob>();
							for (i in 0...$v{filenames.length}) {
								var data = Reflect.field(Shaders, $v { dataName } + i);
								var bytes: haxe.io.Bytes = haxe.Unserializer.run(data);
								blobs.push(kha.Blob.fromBytes(bytes));
							}
							$i { fixedName } = new kha.graphics4.TessellationEvaluationShader(blobs, $v { filenames });
						}
					};
				}
				else if (name.endsWith("_vert")) {
					fields.push({
						name: fixedName,
						doc: null,
						meta: [],
						access: [APublic, AStatic],
						kind: FVar(macro: kha.graphics4.VertexShader, macro null),
						pos: Context.currentPos()
					});
					
					init = macro {
						$init;
						{
							var blobs = new Array<Blob>();
							for (i in 0...$v{filenames.length}) {
								var data = Reflect.field(Shaders, $v { dataName } + i);
								var bytes: haxe.io.Bytes = haxe.Unserializer.run(data);
								blobs.push(kha.Blob.fromBytes(bytes));
							}
							$i { fixedName } = new kha.graphics4.VertexShader(blobs, $v { filenames });
						}
					};
				}
				else {
					fields.push({
						name: fixedName,
						doc: null,
						meta: [],
						access: [APublic, AStatic],
						kind: FVar(macro: kha.graphics4.FragmentShader, macro null),
						pos: Context.currentPos()
					});
					
					init = macro {
						$init;
						{
							var blobs = new Array<Blob>();
							for (i in 0...$v{filenames.length}) {
								var data = Reflect.field(Shaders, $v { dataName } + i);
								var bytes: haxe.io.Bytes = haxe.Unserializer.run(data);
								blobs.push(kha.Blob.fromBytes(bytes));
							}
							$i { fixedName } = new kha.graphics4.FragmentShader(blobs, $v { filenames });
						}
					};
				}
			}
		}
		
		fields.push({
			name: "init",
			doc: null,
			meta: [],
			access: [APublic, AStatic],
			kind: FFun({
				ret: null,
				params: null,
				expr: init,
				args: []
			}),
			pos: Context.currentPos()
		});
		
		return fields;
	}
}
