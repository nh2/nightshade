{-# LANGUAGE LambdaCase, OverloadedStrings #-}

module Nightshade.Format where

import Language.GLSL.Syntax
import Text.PrettyPrint

import Nightshade.Types

formatUniforms :: [ Uniform ] -> Doc
formatUniforms us
  = vcat
    [ "interface" <+> "Uniforms" <+> lbrace
    , nest 2 $ vcat $ map (\u -> formatUniform u <> semi) us
    , rbrace
    ]
    where
      formatUniform ( n, t ) = text n <> colon <+> "Uniform<" <> formatType t <> ">"
      formatType = \case
        Vec2 -> "THREE.Vector2"
        Vec3 -> "THREE.Vector3"
        Mat4 -> "THREE.Matrix4"
        Sampler2D -> "THREE.Texture"
        Int -> "number"
        Float -> "number"
        t -> error ("Unsupported uniform type" ++ show t)

formatShader :: String -> [ Uniform ] -> String -> Doc
formatShader name uniforms src = vcat
  [ "export" <+> "namespace" <+> text name <+> lbrace
  , nest 2 $ vcat
    [ "export" <+> formatUniforms uniforms
    , "export" <+> "const" <+> "Source" <+> equals <+> text (show src)
    ]
  , rbrace
  ]
