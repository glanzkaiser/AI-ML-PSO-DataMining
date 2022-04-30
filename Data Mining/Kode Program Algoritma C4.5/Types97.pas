unit Types97;

interface

const
  // Const from Type Library file Excel_tlb.pas imported from
  // C:\Office\Office\EXCEL8.OLB
  // From Menu of Delphi, select:
  //  Project - Import Type Library - Microsoft Excel 8.0 Object Library

  // XlWBATemplate constants
  xlWBATChart = $FFFFEFF3;
  xlWBATExcel4IntlMacroSheet = $00000004;
  xlWBATExcel4MacroSheet = $00000003;
  xlWBATWorksheet = $FFFFEFB9;

  // XlSheetType constants
  xlChart = $FFFFEFF3;
  xlDialogSheet = $FFFFEFEC;
  xlExcel4IntlMacroSheet = $00000004;
  xlExcel4MacroSheet = $00000003;
  xlWorksheet = $FFFFEFB9;

  // Excel Borders.LineStyles
  xlContinuous = $00000001;
  xlDash = $FFFFEFED;
  xlDashDot = $00000004;
  xlDashDotDot = $00000005;
  xlDot = $FFFFEFEA;
  xlDouble = $FFFFEFE9;
  xlSlantDashDot = $0000000D;
  xlLineStyleNone = $FFFFEFD2;

  // Excel Borders.Weight
  xlHairline = $00000001;
  xlMedium = $FFFFEFD6;
  xlThick = $00000004;
  xlThin = $00000002;

  // Excel Borders.Item()
  xlInsideHorizontal = $0000000C;
  xlInsideVertical = $0000000B;
  xlDiagonalDown = $00000005;
  xlDiagonalUp = $00000006;
  xlEdgeBottom = $00000009;
  xlEdgeLeft = $00000007;
  xlEdgeRight = $0000000A;
  xlEdgeTop = $00000008;

  // Interior.Pattern
  xlPatternAutomatic = $FFFFEFF7;
  xlPatternChecker = $00000009;
  xlPatternCrissCross = $00000010;
  xlPatternDown = $FFFFEFE7;
  xlPatternGray16 = $00000011;
  xlPatternGray25 = $FFFFEFE4;
  xlPatternGray50 = $FFFFEFE3;
  xlPatternGray75 = $FFFFEFE2;
  xlPatternGray8 = $00000012;
  xlPatternGrid = $0000000F;
  xlPatternHorizontal = $FFFFEFE0;
  xlPatternLightDown = $0000000D;
  xlPatternLightHorizontal = $0000000B;
  xlPatternLightUp = $0000000E;
  xlPatternLightVertical = $0000000C;
  xlPatternNone = $FFFFEFD2;
  xlPatternSemiGray75 = $0000000A;
  xlPatternSolid = $00000001;
  xlPatternUp = $FFFFEFBE;
  xlPatternVertical = $FFFFEFBA;

  // XlChartType constants
  xlColumnClustered = $00000033;
  xlColumnStacked = $00000034;
  xlColumnStacked100 = $00000035;
  xl3DColumnClustered = $00000036;
  xl3DColumnStacked = $00000037;
  xl3DColumnStacked100 = $00000038;
  xlBarClustered = $00000039;
  xlBarStacked = $0000003A;
  xlBarStacked100 = $0000003B;
  xl3DBarClustered = $0000003C;
  xl3DBarStacked = $0000003D;
  xl3DBarStacked100 = $0000003E;
  xlLineStacked = $0000003F;
  xlLineStacked100 = $00000040;
  xlLineMarkers = $00000041;
  xlLineMarkersStacked = $00000042;
  xlLineMarkersStacked100 = $00000043;
  xlPieOfPie = $00000044;
  xlPieExploded = $00000045;
  xl3DPieExploded = $00000046;
  xlBarOfPie = $00000047;
  xlXYScatterSmooth = $00000048;
  xlXYScatterSmoothNoMarkers = $00000049;
  xlXYScatterLines = $0000004A;
  xlXYScatterLinesNoMarkers = $0000004B;
  xlAreaStacked = $0000004C;
  xlAreaStacked100 = $0000004D;
  xl3DAreaStacked = $0000004E;
  xl3DAreaStacked100 = $0000004F;
  xlDoughnutExploded = $00000050;
  xlRadarMarkers = $00000051;
  xlRadarFilled = $00000052;
  xlSurface = $00000053;
  xlSurfaceWireframe = $00000054;
  xlSurfaceTopView = $00000055;
  xlSurfaceTopViewWireframe = $00000056;
  xlBubble = $0000000F;
  xlBubble3DEffect = $00000057;
  xlStockHLC = $00000058;
  xlStockOHLC = $00000059;
  xlStockVHLC = $0000005A;
  xlStockVOHLC = $0000005B;
  xlCylinderColClustered = $0000005C;
  xlCylinderColStacked = $0000005D;
  xlCylinderColStacked100 = $0000005E;
  xlCylinderBarClustered = $0000005F;
  xlCylinderBarStacked = $00000060;
  xlCylinderBarStacked100 = $00000061;
  xlCylinderCol = $00000062;
  xlConeColClustered = $00000063;
  xlConeColStacked = $00000064;
  xlConeColStacked100 = $00000065;
  xlConeBarClustered = $00000066;
  xlConeBarStacked = $00000067;
  xlConeBarStacked100 = $00000068;
  xlConeCol = $00000069;
  xlPyramidColClustered = $0000006A;
  xlPyramidColStacked = $0000006B;
  xlPyramidColStacked100 = $0000006C;
  xlPyramidBarClustered = $0000006D;
  xlPyramidBarStacked = $0000006E;
  xlPyramidBarStacked100 = $0000006F;
  xlPyramidCol = $00000070;
  xl3DColumn = $FFFFEFFC;
  xlLine = $00000004;
  xl3DLine = $FFFFEFFB;
  xl3DPie = $FFFFEFFA;
  xlPie = $00000005;
  xlXYScatter = $FFFFEFB7;
  xl3DArea = $FFFFEFFE;
  xlArea = $00000001;
  xlDoughnut = $FFFFEFE8;
  xlRadar = $FFFFEFC9;

  // Const from Type Library file Word_tlb.pas imported from
  // C:\Office\Office\MSWORD8.OLB
  // From Menu of Delphi, select:
  //  Project - Import Type Library - Add - C:\Office\Office\MSWORD8.OLB

  // WdPasteDataType constants for MsWord 97
  wdPasteOLEObject = $00000000;
  wdPasteRTF = $00000001;
  wdPasteText = $00000002;
  wdPasteMetafilePicture = $00000003;
  wdPasteBitmap = $00000004;
  wdPasteDeviceIndependentBitmap = $00000005;
  wdPasteHyperlink = $00000007;
  wdPasteShape = $00000008;
  wdPasteEnhancedMetafile = $00000009;

  // Const from Type Library file Office_tlb.pas imported from
  // C:\Office\Office\MSO97.DLL
  // From Menu of Delphi, select:
  //  Project - Import Type Library Microsoft Office 8.0 Object Library

  // MsoAutoShapeType constants
  msoShapeMixed = $FFFFFFFE;
  msoShapeRectangle = $00000001;
  msoShapeParallelogram = $00000002;
  msoShapeTrapezoid = $00000003;
  msoShapeDiamond = $00000004;
  msoShapeRoundedRectangle = $00000005;
  msoShapeOctagon = $00000006;
  msoShapeIsoscelesTriangle = $00000007;
  msoShapeRightTriangle = $00000008;
  msoShapeOval = $00000009;
  msoShapeHexagon = $0000000A;
  msoShapeCross = $0000000B;
  msoShapeRegularPentagon = $0000000C;
  msoShapeCan = $0000000D;
  msoShapeCube = $0000000E;
  msoShapeBevel = $0000000F;
  msoShapeFoldedCorner = $00000010;
  msoShapeSmileyFace = $00000011;
  msoShapeDonut = $00000012;
  msoShapeNoSymbol = $00000013;
  msoShapeBlockArc = $00000014;
  msoShapeHeart = $00000015;
  msoShapeLightningBolt = $00000016;
  msoShapeSun = $00000017;
  msoShapeMoon = $00000018;
  msoShapeArc = $00000019;
  msoShapeDoubleBracket = $0000001A;
  msoShapeDoubleBrace = $0000001B;
  msoShapePlaque = $0000001C;
  msoShapeLeftBracket = $0000001D;
  msoShapeRightBracket = $0000001E;
  msoShapeLeftBrace = $0000001F;
  msoShapeRightBrace = $00000020;
  msoShapeRightArrow = $00000021;
  msoShapeLeftArrow = $00000022;
  msoShapeUpArrow = $00000023;
  msoShapeDownArrow = $00000024;
  msoShapeLeftRightArrow = $00000025;
  msoShapeUpDownArrow = $00000026;
  msoShapeQuadArrow = $00000027;
  msoShapeLeftRightUpArrow = $00000028;
  msoShapeBentArrow = $00000029;
  msoShapeUTurnArrow = $0000002A;
  msoShapeLeftUpArrow = $0000002B;
  msoShapeBentUpArrow = $0000002C;
  msoShapeCurvedRightArrow = $0000002D;
  msoShapeCurvedLeftArrow = $0000002E;
  msoShapeCurvedUpArrow = $0000002F;
  msoShapeCurvedDownArrow = $00000030;
  msoShapeStripedRightArrow = $00000031;
  msoShapeNotchedRightArrow = $00000032;
  msoShapePentagon = $00000033;
  msoShapeChevron = $00000034;
  msoShapeRightArrowCallout = $00000035;
  msoShapeLeftArrowCallout = $00000036;
  msoShapeUpArrowCallout = $00000037;
  msoShapeDownArrowCallout = $00000038;
  msoShapeLeftRightArrowCallout = $00000039;
  msoShapeUpDownArrowCallout = $0000003A;
  msoShapeQuadArrowCallout = $0000003B;
  msoShapeCircularArrow = $0000003C;
  msoShapeFlowchartProcess = $0000003D;
  msoShapeFlowchartAlternateProcess = $0000003E;
  msoShapeFlowchartDecision = $0000003F;
  msoShapeFlowchartData = $00000040;
  msoShapeFlowchartPredefinedProcess = $00000041;
  msoShapeFlowchartInternalStorage = $00000042;
  msoShapeFlowchartDocument = $00000043;
  msoShapeFlowchartMultidocument = $00000044;
  msoShapeFlowchartTerminator = $00000045;
  msoShapeFlowchartPreparation = $00000046;
  msoShapeFlowchartManualInput = $00000047;
  msoShapeFlowchartManualOperation = $00000048;
  msoShapeFlowchartConnector = $00000049;
  msoShapeFlowchartOffpageConnector = $0000004A;
  msoShapeFlowchartCard = $0000004B;
  msoShapeFlowchartPunchedTape = $0000004C;
  msoShapeFlowchartSummingJunction = $0000004D;
  msoShapeFlowchartOr = $0000004E;
  msoShapeFlowchartCollate = $0000004F;
  msoShapeFlowchartSort = $00000050;
  msoShapeFlowchartExtract = $00000051;
  msoShapeFlowchartMerge = $00000052;
  msoShapeFlowchartStoredData = $00000053;
  msoShapeFlowchartDelay = $00000054;
  msoShapeFlowchartSequentialAccessStorage = $00000055;
  msoShapeFlowchartMagneticDisk = $00000056;
  msoShapeFlowchartDirectAccessStorage = $00000057;
  msoShapeFlowchartDisplay = $00000058;
  msoShapeExplosion1 = $00000059;
  msoShapeExplosion2 = $0000005A;
  msoShape4pointStar = $0000005B;
  msoShape5pointStar = $0000005C;
  msoShape8pointStar = $0000005D;
  msoShape16pointStar = $0000005E;
  msoShape24pointStar = $0000005F;
  msoShape32pointStar = $00000060;
  msoShapeUpRibbon = $00000061;
  msoShapeDownRibbon = $00000062;
  msoShapeCurvedUpRibbon = $00000063;
  msoShapeCurvedDownRibbon = $00000064;
  msoShapeVerticalScroll = $00000065;
  msoShapeHorizontalScroll = $00000066;
  msoShapeWave = $00000067;
  msoShapeDoubleWave = $00000068;
  msoShapeRectangularCallout = $00000069;
  msoShapeRoundedRectangularCallout = $0000006A;
  msoShapeOvalCallout = $0000006B;
  msoShapeCloudCallout = $0000006C;
  msoShapeLineCallout1 = $0000006D;
  msoShapeLineCallout2 = $0000006E;
  msoShapeLineCallout3 = $0000006F;
  msoShapeLineCallout4 = $00000070;
  msoShapeLineCallout1AccentBar = $00000071;
  msoShapeLineCallout2AccentBar = $00000072;
  msoShapeLineCallout3AccentBar = $00000073;
  msoShapeLineCallout4AccentBar = $00000074;
  msoShapeLineCallout1NoBorder = $00000075;
  msoShapeLineCallout2NoBorder = $00000076;
  msoShapeLineCallout3NoBorder = $00000077;
  msoShapeLineCallout4NoBorder = $00000078;
  msoShapeLineCallout1BorderandAccentBar = $00000079;
  msoShapeLineCallout2BorderandAccentBar = $0000007A;
  msoShapeLineCallout3BorderandAccentBar = $0000007B;
  msoShapeLineCallout4BorderandAccentBar = $0000007C;
  msoShapeActionButtonCustom = $0000007D;
  msoShapeActionButtonHome = $0000007E;
  msoShapeActionButtonHelp = $0000007F;
  msoShapeActionButtonInformation = $00000080;
  msoShapeActionButtonBackorPrevious = $00000081;
  msoShapeActionButtonForwardorNext = $00000082;
  msoShapeActionButtonBeginning = $00000083;
  msoShapeActionButtonEnd = $00000084;
  msoShapeActionButtonReturn = $00000085;
  msoShapeActionButtonDocument = $00000086;
  msoShapeActionButtonSound = $00000087;
  msoShapeActionButtonMovie = $00000088;
  msoShapeBalloon = $00000089;
  msoShapeNotPrimitive = $0000008A;

// MsoPresetTextEffect constants
  msoTextEffectMixed = $FFFFFFFE;
  msoTextEffect1 = $00000000;
  msoTextEffect2 = $00000001;
  msoTextEffect3 = $00000002;
  msoTextEffect4 = $00000003;
  msoTextEffect5 = $00000004;
  msoTextEffect6 = $00000005;
  msoTextEffect7 = $00000006;
  msoTextEffect8 = $00000007;
  msoTextEffect9 = $00000008;
  msoTextEffect10 = $00000009;
  msoTextEffect11 = $0000000A;
  msoTextEffect12 = $0000000B;
  msoTextEffect13 = $0000000C;
  msoTextEffect14 = $0000000D;
  msoTextEffect15 = $0000000E;
  msoTextEffect16 = $0000000F;
  msoTextEffect17 = $00000010;
  msoTextEffect18 = $00000011;
  msoTextEffect19 = $00000012;
  msoTextEffect20 = $00000013;
  msoTextEffect21 = $00000014;
  msoTextEffect22 = $00000015;
  msoTextEffect23 = $00000016;
  msoTextEffect24 = $00000017;
  msoTextEffect25 = $00000018;
  msoTextEffect26 = $00000019;
  msoTextEffect27 = $0000001A;
  msoTextEffect28 = $0000001B;
  msoTextEffect29 = $0000001C;
  msoTextEffect30 = $0000001D;

  // MsoGradientStyle constants
  msoGradientMixed = $FFFFFFFE;
  msoGradientHorizontal = $00000001;
  msoGradientVertical = $00000002;
  msoGradientDiagonalUp = $00000003;
  msoGradientDiagonalDown = $00000004;
  msoGradientFromCorner = $00000005;
  msoGradientFromTitle = $00000006;
  msoGradientFromCenter = $00000007;

  // MsoPresetExtrusionDirection constants
  msoPresetExtrusionDirectionMixed = $FFFFFFFE;
  msoExtrusionBottomRight = $00000001;
  msoExtrusionBottom = $00000002;
  msoExtrusionBottomLeft = $00000003;
  msoExtrusionRight = $00000004;
  msoExtrusionNone = $00000005;
  msoExtrusionLeft = $00000006;
  msoExtrusionTopRight = $00000007;
  msoExtrusionTop = $00000008;
  msoExtrusionTopLeft = $00000009;

implementation

end.
 