package alternativa.engine3d.shadow
{
	import utils.adobe.utils.AGALMiniAssembler;
	import utils.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.Bitmap;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Lesson4 extends Main
	{
		private var vertexBuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D;
		private var meshVertexData:Vector.<Number>;
		private var meshIndexData:Vector.<uint>;
		
		private var projectionMatrix:PerspectiveMatrix3D = new PerspectiveMatrix3D();
		private var modelMatrix:Matrix3D = new Matrix3D();
		private var viewMatrix:Matrix3D = new Matrix3D();
		private var modelViewMatrix:Matrix3D = new Matrix3D();
		
		private var modelViewProjection:Matrix3D = new Matrix3D();
		
		private var shaderProgram1:Program3D;
		private var shaderProgram2:Program3D;
		private var shaderProgram3:Program3D;
		private var shaderProgram4:Program3D;
		
		private var t:Number = 0;
		private var looptemp:int = 0;
		
		[Embed (source = "Assets/texture.jpg")] private var myTextureBitmap:Class;
		private var myTextureData:Bitmap = new myTextureBitmap();
		private var myTexture:Texture;
		public function Lesson4()
		{
			super();
			initText();
		}
		
		private function createTf(tfx:Number, tfy:Number, txt:String):void
		{
			var myFormat:TextFormat = new TextFormat();
			myFormat.color = 0xffffff;
			myFormat.size = 13;
			
			var tf:TextField = new TextField();
			tf.x = tfx;
			tf.y = tfy;
			tf.text = txt;
			tf.defaultTextFormat = myFormat;
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(tf);
		}
		
		private function initText():void
		{
//			createTf(100, 180, 
		}
		private function initShader():void
		{
			var vertexShader:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShader.assemble(
				Context3DProgramType.VERTEX,
				"m44 op, va0, vc0\n"+
				"mov v0, va0\n"+
				"mov v1, va1\n"+
				"mov v2, va2\n"
				);
			var fragmentShader1:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShader1.assemble(
				Context3DProgramType.FRAGMENT,
				"tex ft0, v1, fs0 <2d, repeat, miplinear>\n"+
				"mov oc, ft0\n"
				);
			var fragmentShader2:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShader2.assemble(
				Context3DProgramType.FRAGMENT,
				"mov oc, v2\n"
				);
			
			var fragmentShader3:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShader3.assemble(
				Context3DProgramType.FRAGMENT,
				"tex ft0, v1, fs0 <2d,repeat, miplinear>\n"+
				"mul ft1, v2, ft0\n"+
				"mov oc, ft1\n"
				);
			var fragmentShader4:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShader4.assemble(
				Context3DProgramType.FRAGMENT,
				"tex ft0, v1, fs0 <2d, repeat, miplinear>\n"+
				"mul ft1, fc0, ft0\n"+
				"mov oc, ft1\n"
				);
			
			shaderProgram1 = context3D.createProgram();
			shaderProgram1.upload(
				vertexShader.agalcode,
				fragmentShader1.agalcode);
			shaderProgram2 = context3D.createProgram();
			shaderProgram2.upload(
				vertexShader.agalcode,
				fragmentShader2.agalcode);
			shaderProgram3 = context3D.createProgram();
			shaderProgram3.upload(
				vertexShader.agalcode,
				fragmentShader3.agalcode);
			shaderProgram4 = context3D.createProgram();
			shaderProgram4.upload(
				vertexShader.agalcode,
				fragmentShader4.agalcode);
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
			// Position XYZ, texture coord UV, normal XYZ, vertex RGBA
			meshVertexData = Vector.<Number> 
				( [
					//X,  Y,  Z,   U, V,   nX, nY, nZ,	R,	G,	B,	A
					-1, -1,  1,   0, 0,   0,  0,  1,	1.0,0.0,0.0,1.0,
					1, -1,  1,   1, 0,   0,  0,  1,	0.0,1.0,0.0,1.0,
					1,  1,  1,   1, 1,   0,  0,  1,	0.0,0.0,1.0,1.0,
					-1,  1,  1,   0, 1,   0,  0,  1,	1.0,1.0,1.0,1.0
				]);
		}		
		override protected function init3DData():void
		{
			initData();
			initShader();
			
			indexBuffer = context3D.createIndexBuffer(meshIndexData.length);
			indexBuffer.uploadFromVector(
				meshIndexData, 0, meshIndexData.length);
			
			
			vertexBuffer = context3D.createVertexBuffer(meshVertexData.length/12, 12);
			vertexBuffer.uploadFromVector(meshVertexData, 0, meshVertexData.length/12);
			
			myTexture = Main.drawTexture(context3D, myTextureData.bitmapData);
			
			projectionMatrix.identity();
			projectionMatrix.perspectiveFieldOfViewRH(45, swfWidth/swfHeight, 0.01, 100);
			
			viewMatrix.identity();
			viewMatrix.appendTranslation(0, 0, -10);
			
		}
		override protected function updateFrame(evt:Event):void
		{
			context3D.clear(1,1,1);
			t += 2;
			
			for (looptemp=0; looptemp<4; looptemp++)
			{
				modelMatrix.identity();
				switch(looptemp)
				{
					case 0:
					{
						context3D.setTextureAt(0, myTexture);
						context3D.setProgram(shaderProgram1);
						modelMatrix.appendRotation(t*0.7, Vector3D.Y_AXIS);
						modelMatrix.appendRotation(t*0.6, Vector3D.X_AXIS);
						modelMatrix.appendRotation(t*0.1, Vector3D.Y_AXIS);
						modelMatrix.appendTranslation(-3, 3, 0);
						break;
					}
					case 1:
					{
						context3D.setTextureAt(0, null);
						context3D.setProgram(shaderProgram2);
						modelMatrix.appendRotation(t*1, Vector3D.Y_AXIS);
						modelMatrix.appendRotation(t*-0.2, Vector3D.X_AXIS);
						modelMatrix.appendRotation(t*0.3, Vector3D.Y_AXIS);
						modelMatrix.appendTranslation(3, 3, 0);
						break;
					}
					case 2:
					{
						context3D.setTextureAt(0, myTexture);
						context3D.setProgram(shaderProgram3);
						modelMatrix.appendRotation(t*0.7, Vector3D.Y_AXIS);
						modelMatrix.appendRotation(t*0.6, Vector3D.X_AXIS);
						modelMatrix.appendRotation(t*0.1, Vector3D.Y_AXIS);
						modelMatrix.appendTranslation(3, -3, 0);
					}
					case 3:
					{
						context3D.setProgram(shaderProgram4);
						context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,
							0, Vector.<Number>([1, Math.abs(Math.cos(t/50)), 0, 1]) );
						context3D.setTextureAt(0, myTexture);
						context3D.setProgram(shaderProgram4);
						modelMatrix.appendRotation(t*0.7, Vector3D.Y_AXIS);
						modelMatrix.appendRotation(t*0.6, Vector3D.X_AXIS);
						modelMatrix.appendRotation(t*0.1, Vector3D.Y_AXIS);
						modelMatrix.appendTranslation(-3, -3, 0);
						break;
					}
					default:
					{
						break;
					}
				}
				
				modelViewProjection.identity();
				modelViewProjection.append(modelMatrix);
				modelViewProjection.append(viewMatrix);
				modelViewProjection.append(projectionMatrix);
				
				context3D.setProgramConstantsFromMatrix(
					Context3DProgramType.VERTEX, 
					0, modelViewProjection, true );

				// associate the vertex data with current shader program
				// position
				context3D.setVertexBufferAt(0, vertexBuffer, 0, 
					Context3DVertexBufferFormat.FLOAT_3);
				// tex coord
				context3D.setVertexBufferAt(1, vertexBuffer, 3, 
					Context3DVertexBufferFormat.FLOAT_2);
				// vertex rgba
				context3D.setVertexBufferAt(2, vertexBuffer, 8, 
					Context3DVertexBufferFormat.FLOAT_4);
				
				// finally draw the triangles
				context3D.drawTriangles(
					indexBuffer, 0, meshIndexData.length/3);
				
			}
			
			context3D.present();
		}
	}
}