package agalLesson
{
	import utils.adobe.utils.AGALMiniAssembler;
	import utils.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class Lesson3 extends Main
	{
		// the compiled shader used to render our mesh
		private var shaderProgram:Program3D;
		// the uploaded verteces used by our mesh
		private var vertexBuffer:VertexBuffer3D;
		// the uploaded indeces of each vertex of the mesh
		private var indexBuffer:IndexBuffer3D;
		// the data that defines our 3d mesh model
		private var meshVertexData:Vector.<Number>;
		// the indeces that define what data is used by each vertex
		private var meshIndexData:Vector.<uint>;
		
		// matrices that affect the mesh location and camera angles
		private var projectionMatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D();
		private var modelMatrix:Matrix3D = new Matrix3D();
		private var viewMatrix:Matrix3D = new Matrix3D();
		private var modelViewProjection:Matrix3D = new Matrix3D();
		// a simple frame counter used for animation
		private var t:Number = 0;
		
		/* TEXTURE: Pure AS3 and Flex version:
		* if you are using Adobe Flash CS5 comment out the next two lines of code */
		[Embed (source = "Assets/texture.jpg")] private var myTextureBitmap:Class;
		private var myTextureData:Bitmap = new myTextureBitmap();
		private var myTexture:Texture;
		public function Lesson3()
		{
			super();
		}
		private function initData():void 
		{
			// Defines which vertex is used for each polygon
			// In this example a square is made from two triangles
			meshIndexData = Vector.<uint> 
				([
					0, 1, 2, 		0, 2, 3,
				]);
			
			// Raw data used for each of the 4 verteces
			// Position XYZ, texture coordinate UV, normal XYZ
			meshVertexData = Vector.<Number> 
				( [
					//X,  Y,  Z,   U, V,   nX, nY, nZ		
					-1, -1,  1,   0, 0,   0,  0,  1,
					1, -1,  1,   1, 0,   0,  0,  1,
					1,  1,  1,   1, 1,   0,  0,  1,
					-1,  1,  1,   0, 1,   0,  0,  1
				]);
		}		
		override protected function init3DData():void
		{
			initData();
			
			// A simple vertex shader which does a 3D transformation
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble
				( 
					Context3DProgramType.VERTEX,
					// 4x4 matrix multiply to get camera angle	
					"m44 op, va0, vc0\n" +
					// tell fragment shader about XYZ
					"mov v0, va0\n" +
					// tell fragment shader about UV
					"mov v1, va1\n"
				);			
			
			// A simple fragment shader which will use the vertex position as a color
			var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShaderAssembler.assemble
				( 
					Context3DProgramType.FRAGMENT,	
					// grab the texture color from texture fs0
					// using the UV coordinates stored in v1
					"tex ft0, v1, fs0 <2d,repeat,miplinear>\n" +	
					// move this value to the output color
					"mov oc, ft0\n"									
				);
			
			// combine shaders into a program which we then upload to the GPU
			shaderProgram = context3D.createProgram();
			shaderProgram.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			
			// upload the mesh indexes
			indexBuffer = context3D.createIndexBuffer(meshIndexData.length);
			indexBuffer.uploadFromVector(meshIndexData, 0, meshIndexData.length);
			
			// upload the mesh vertex data
			// since our particular data is 
			// x, y, z, u, v, nx, ny, nz
			// each vertex uses 8 array elements
			vertexBuffer = context3D.createVertexBuffer(meshVertexData.length/8, 8); 
			vertexBuffer.uploadFromVector(meshVertexData, 0, meshVertexData.length/8);
			
			// Generate mipmaps
			myTexture = drawTexture(context3D, myTextureData.bitmapData);
			
			// create projection matrix for our 3D scene
			projectionMatrix.identity();
			// 45 degrees FOV, 640/480 aspect ratio, 0.1=near, 100=far
			projectionMatrix.perspectiveFieldOfViewRH(45.0, swfWidth / swfHeight, 0.01, 100.0);
			
			// create a matrix that defines the camera location
			viewMatrix.identity();
			// move the camera back a little so we can see the mesh
			viewMatrix.appendTranslation(0,0,-4);
			
		}
		
		override protected function updateFrame(evt:Event):void
		{
			// clear scene before rendering is mandatory
			context3D.clear(0,0,0); 
			
			context3D.setProgram ( shaderProgram );
			
			// create the various transformation matrices
			modelMatrix.identity();
			modelMatrix.appendRotation(t*0.7, Vector3D.Y_AXIS);
			modelMatrix.appendRotation(t*0.6, Vector3D.X_AXIS);
			modelMatrix.appendRotation(t*1.0, Vector3D.Y_AXIS);
			modelMatrix.appendTranslation(0.0, 0.0, 0.0);
			modelMatrix.appendRotation(90.0, Vector3D.X_AXIS);
			
			// rotate more next frame
			t += 2.0;
			
			// clear the matrix and append new angles
			modelViewProjection.identity();
			modelViewProjection.append(modelMatrix);
			modelViewProjection.append(viewMatrix);
			modelViewProjection.append(projectionMatrix);
			
			// pass our matrix data to the shader program
			context3D.setProgramConstantsFromMatrix(
				Context3DProgramType.VERTEX, 
				0, modelViewProjection, true );
			
			// associate the vertex data with current shader program
			// position
			context3D.setVertexBufferAt(0, vertexBuffer, 0, 
				Context3DVertexBufferFormat.FLOAT_3);
			// tex coord
			context3D.setVertexBufferAt(1, vertexBuffer, 3, 
				Context3DVertexBufferFormat.FLOAT_3);
			
			// which texture should we use?
			context3D.setTextureAt(0, myTexture);
			
			// finally draw the triangles
			context3D.drawTriangles(indexBuffer, 0, meshIndexData.length/3);
			
			// present/flip back buffer
			context3D.present();
		}
	}
}