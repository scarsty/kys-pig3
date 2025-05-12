/********************************************************************
  this is a part of sfe2
  Created by MythKAst
  ©2013 MythKAst Some rights reserved.


  You can build it with vs2010,mono
  Anybody who gets this source code is able to modify or rebuild it anyway,
  but please keep this section when you want to spread a new version.
  It's strongly not recommended to change the original copyright. Adding new version
  information, however, is Allowed. Thanks.
  For the latest version, please be sure to check my website:
  https://code.google.com/p/sfe2


  你可以用vs2010,mono编译这些代码
  任何得到此代码的人都可以修改或者重新编译这段代码，但是请保留这段文字。
  请不要修改原始版权，但是可以添加新的版本信息。
  最新版本请留意：https://code.google.com/p/sfe2

 MythKAst(asdic182@sina.com), in 2013 June.
*********************************************************************/
using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Data;
using NPOI;
using NPOI.HSSF.UserModel;
using NPOI.XSSF.UserModel;
using NPOI.HPSF;
using NPOI.POIFS.FileSystem;
using NPOI.SS.UserModel;
using ICSharpCode.SharpZipLib;
using ICSharpCode.SharpZipLib.Zip;
using System.Collections;
//using System.
namespace imzopr.rdata
{
    public class Rcore
    {
        public enum stringCodeType
        {
            GBK = 0,
            BIG5 = 1,
        }
        public enum datatypeenum
        {
            int_data = 0,
            string_data = 1,
            uint_data = 2,
        }
        public class RsaveType
        {
            public Stream RsaveStream;
            public List<int> Rindex;
            public RsaveType()
            {
                Rindex = new List<int>();
            }
            public void Dispose()
            {
                RsaveStream = null;
                Rindex = null; 
            }
        }
        public class RbyteType
        {
            //public string dataStr;
            public datatypeenum dataType;//0 int 1 string 2uint
            public object data;
            public string dataName;
            public int dataNum;
            public string descriptionStr;
            public int TypeDef;//
        }
        public class Rfile
        {
            public string GRPfilename;
            public string Idxfilename;
        }
        public class Rdata0Type
        {
            public List<RbyteType> Rbyte;
            public int keyNameIndex;
        }
        public class RdataType
        {
            public List<Rdata0Type> Rdata0;
            public string TypeName;
            public void FromXls(string fileDest, string rinifilepath)
            {
                HSSFWorkbook hssfworkbook;
                ICell cell;
                //Rdata0.Clear();
                List<inilist.R_modify> rini = inilist.ini2list(rinifilepath);
                using (FileStream file = new FileStream(fileDest, FileMode.Open, FileAccess.Read))
                {
                    hssfworkbook = new HSSFWorkbook(file);
                }
                for (int RiniIndex = 0; RiniIndex < rini.Count; RiniIndex++)
                {
                    ISheet sheet = hssfworkbook.GetSheetAt(RiniIndex);
                    IEnumerator rows = sheet.GetRowEnumerator();
                    rows.MoveNext();//skip header
                    while (rows.MoveNext())
                    {
                        IRow row = (HSSFRow)rows.Current;
                        for (int j = 1; j < row.Cells.Count; j++)
                        {

                        }
                        for (int j = 1; j < 5 + 1; j++)
                        {

                            cell = row.GetCell(j);
                            int a = (int)cell.NumericCellValue;
                        }
                    }
                }
            }
            public object[,] ToArray()
            {
                object[,] tmpArray = null;
                //可能可以转置矩阵
                if (Rdata0.Count > 0 && Rdata0[0].Rbyte.Count < 255)
                {
                    //937,2
                    tmpArray = new object[Rdata0[0].Rbyte.Count,Rdata0.Count + 2];
                    //header
                    for (int i = 0; i < Rdata0[0].Rbyte.Count; i++)
                    {
                        tmpArray[i, 0] = Rdata0[0].Rbyte[i].dataName;
                        tmpArray[i, 1] = Rdata0[0].Rbyte[i].dataType.ToString() + ":" + Rdata0[0].Rbyte[i].dataNum.ToString();
                    }
                    //data
                    for (int j = 0; j < Rdata0.Count; j++)
                        for (int i = 0; i < Rdata0[0].Rbyte.Count; i++)
                            tmpArray[i, j + 2] = Rdata0[j].Rbyte[i].data;
                }
                else
                {
                    //2,937
                    tmpArray = new object[Rdata0.Count + 2, Rdata0[0].Rbyte.Count];
                    //header
                    for (int i = 0; i < Rdata0[0].Rbyte.Count; i++)
                    {
                        tmpArray[0, i] = Rdata0[0].Rbyte[i].dataName;
                        tmpArray[1, i] = Rdata0[0].Rbyte[i].dataType.ToString() + ":" + Rdata0[0].Rbyte[i].dataNum.ToString(); ;
                    }
                    //data
                    for (int j = 0; j < Rdata0.Count; j++)
                        for (int i = 0; i < Rdata0[0].Rbyte.Count; i++)
                            tmpArray[j + 2, i] = Rdata0[j].Rbyte[i].data;
                }
                return tmpArray;
            }
            //public int TypeDef;
        }
        public class RNametype
        {
            public List<string> Rname;
            public List<string> Rgrp;
            public List<string> Ridx;
            public RNametype()
            {
                Rname = new List<string>();
                Rgrp = new List<string>();
                Ridx = new List<string>();
            }
        }
        public static void SaveRToXls(Stream filegrp, string fileidx, string inifilepath, string xlsFile)
        {
            XSSFWorkbook newBook = new XSSFWorkbook();

            List<object> rows = new List<object>();
            List<RdataType> datalist = ReadRanger(filegrp, fileidx, inifilepath);
            for (int k = 0; k < datalist.Count; k++)
            {
                object[,] array = datalist[k].ToArray();
                XSSFSheet newSheet = (XSSFSheet)newBook.CreateSheet(datalist[k].TypeName);//新建工作簿
                
                for (int i = 0; i < array.GetLength(1); i++)
                {
                    XSSFRow newRow = (XSSFRow)newSheet.CreateRow(i);//创建行
                    for (int j = 0; j < array.GetLength(0); j++)
                    {
                        if(array[j,i].GetType() == typeof(String))
                            newSheet.GetRow(i).CreateCell(j).SetCellValue((string)array[j, i]);
                        else
                            newSheet.GetRow(i).CreateCell(j).SetCellValue((int)array[j, i]);
                    }
                }
                //newSheet.AutoSizeColumn(-2);
            }
            FileStream fs = new FileStream(xlsFile, FileMode.Create);
            newBook.Write(fs);
            fs.Close();
            fs.Dispose();

        }
        private static bool IsType(string str)
        {
            if (str.Contains("_data:")) return true;
            return false;
        }
        public static RsaveType saveRanger(object[][][] objectData,stringCodeType codetype= stringCodeType.BIG5)
        {
            RsaveType rsavetype = new RsaveType();
            MemoryStream stream = new MemoryStream();
            BinaryWriter bw = new BinaryWriter(stream);
            //List<int> tmpindex = new List<int>();
            int tmpRdataLength = 0;
            for (int i = 0; i < objectData.Length; i++)
            {
                tmpRdataLength = 0;
                for (int j = 2; j < objectData[i].Length; j++)
                {
                    for (int k = 0; k < objectData[i][j].Length; k++)
                    {
                        string[] tmpstr = objectData[i][1][k].ToString().Split(':'); 
                        int tmplength = int.Parse(tmpstr[1]);
                        //if (tmplength == 20) 
                        //    Console.WriteLine("1");
                        switch (tmpstr[0])
                        {
                            case "int_data":
                                bw.Write(Convert.ToInt16(objectData[i][j][k]));
                                break;
                            case "uint_data":
                                bw.Write(Convert.ToUInt16(objectData[i][j][k]));
                                break;
                            case "long_data":
                                bw.Write(Convert.ToInt32(objectData[i][j][k]));
                                break;
                            case "string_data":   
                                byte[] tmpbyte = null;
                                switch (codetype)
                                {
                                    case stringCodeType.BIG5:
                                        tmpbyte = sfeadd.Str.UnicodeToBig5((string)objectData[i][j][k], tmplength);
                                        break;
                                    case stringCodeType.GBK:
                                        tmpbyte = sfeadd.Str.UnicodeToGBK((string)objectData[i][j][k], tmplength);
                                        break;
                                }
                                bw.Write(tmpbyte);
                                break;
                        }
                        tmpRdataLength += tmplength;
                    }
                }
                rsavetype.Rindex.Add(tmpRdataLength);
            }
            //objectData = null;
            rsavetype.RsaveStream = stream;
            return rsavetype;
        }
        public static object[][][] FromXls(string xlsFile)
        {
            try
            {
                XSSFWorkbook hssfworkbook;
                List<object[][]> tmpResult = new List<object[][]>();
                using (FileStream file = new FileStream(xlsFile, FileMode.Open, FileAccess.Read))
                {
                    hssfworkbook = new XSSFWorkbook(file);
                }
                for (int sheetCount = 0; sheetCount < hssfworkbook.NumberOfSheets; sheetCount++)
                {
                    ISheet sheet = hssfworkbook.GetSheetAt(sheetCount);

                    IEnumerator rows = sheet.GetRowEnumerator();
                    List<object[]> tmpRowList = new List<object[]>();
                    while (rows.MoveNext())
                    {
                        IRow row = (XSSFRow)rows.Current;
                        List<object> tmpRow = new List<object>();
                        foreach (ICell cell in row.Cells)
                        {
                            switch (cell.CellType)
                            {
                                case CellType.Numeric:
                                    tmpRow.Add(cell.NumericCellValue);
                                    break;
                                case CellType.String:
                                    tmpRow.Add(cell.StringCellValue);
                                    break;
                                default:
                                    tmpRow.Add(cell.StringCellValue);
                                    break;
                            }
                        }
                        tmpRowList.Add(tmpRow.ToArray());
                    }
                    if (!IsType(tmpRowList[1][0].ToString()))
                    {
                        List<object[]> tmpTrans = new List<object[]>();
                        //转置矩阵
                        for (int j = 0; j < tmpRowList[0].Length; j++)
                        {
                            List<object> tmpPerTrans = new List<object>();
                            for (int i = 0; i < tmpRowList.Count; i++)
                            {
                                tmpPerTrans.Add(tmpRowList[i][j]);
                            }
                            tmpTrans.Add(tmpPerTrans.ToArray());
                        }
                        tmpResult.Add(tmpTrans.ToArray());
                    }
                    else
                    {
                        tmpResult.Add(tmpRowList.ToArray());
                    }
                }
                //cell = row.GetCell(2);
                return tmpResult.ToArray();
            }
            catch { return null; }
        }
        public static List<RdataType> ReadRanger(Stream filegrp, string fileidx, string inifilepath)
        {
            //try
            {
                List<inilist.R_modify> rini = inilist.ini2list(inifilepath);
                List<RdataType> RMem = new List<RdataType>();

                inireader sfeini = new inireader(inifilepath);
                string codetype = sfeini.ReadIniString("R_Modify", "StringCodeType","big5");
                //readidx
                List<int> rindex = new List<int>();
                using (FileStream fs = new FileStream(fileidx, FileMode.Open))
                using (BinaryReader br = new BinaryReader(fs))
                {
                    rindex.Add((int)0);
                    for (int i = 0; i < fs.Length / 4 - 1; i++)
                    {
                        rindex.Add(br.ReadInt32());
                    }
                }
                //calc rini
                int[] Rlong = new int[rini.Count];
                for (int i = 0; i < rini.Count; i++)
                {
                    for (int j = 0; j < rini[i].ListR.Count; j++)
                    {
                        Rlong[i] += int.Parse(rini[i].ListR[j].dataNum) *
                                    int.Parse(rini[i].ListR[j].dataStructNum) *
                                    int.Parse(rini[i].ListR[j].byteNum);
                    }
                }
                //readgrp

                //using (FileStream fs = new FileStream(RfilePath.GRPfilename, FileMode.Open))
                using (BinaryReader br = new BinaryReader(filegrp))
                {
                    rindex.Add((int)filegrp.Length);
                    for (int i = 0; i < rindex.Count - 1; i++)
                    {
                        RdataType Rdata = new RdataType();
                        Rdata.Rdata0 = new List<Rdata0Type>();
                        long tmpIndex = (long)rindex[i];
                        Rdata.TypeName = rini[i].typeName;
                        int tmpRdataNum = (int)(((long)rindex[i + 1] - tmpIndex) / Rlong[i]);
                        for (int rnum = 0; rnum < tmpRdataNum; rnum++)
                        {
                            Rdata0Type Rdata0 = new Rdata0Type();
                            Rdata0.Rbyte = new List<RbyteType>();
                            Rdata0.keyNameIndex = -1;
                            for (int ptrRiniIndex = 0; ptrRiniIndex < rini[i].ListR.Count; ptrRiniIndex += 0)
                            {
                                if (rini[i].ListR[ptrRiniIndex].isName == "1")
                                    Rdata0.keyNameIndex = Rdata0.Rbyte.Count;

                                int tmpdatanum = int.Parse(rini[i].ListR[ptrRiniIndex].dataNum);
                                int tmpdataStructNum = int.Parse(rini[i].ListR[ptrRiniIndex].dataStructNum);
                                for (int j = 0; j < tmpdatanum; j++)
                                {
                                    for (int k = 0; k < tmpdataStructNum; k++)
                                    {
                                        RbyteType Rtmp = new RbyteType();
                                        switch (rini[i].ListR[ptrRiniIndex + k].isString)
                                        {
                                            //int
                                            case "0":
                                                Rtmp.dataType = datatypeenum.int_data;
                                                Rtmp.data = (int)br.ReadInt16();
                                                break;
                                            //str
                                            case "1":
                                                Rtmp.dataType = datatypeenum.string_data;
                                                string dataTradional = string.Empty;
                                                switch (codetype.ToLower())
                                                {
                                                    case "big5":
                                                        dataTradional = sfeadd.Str.Big5ToUnicode(br.ReadBytes(
                                                            int.Parse(rini[i].ListR[ptrRiniIndex + k].byteNum))
                                                            ).Trim();
                                                        break;
                                                    case "gbk":
                                                        dataTradional = sfeadd.Str.GBKToUnicode(br.ReadBytes(
                                                            int.Parse(rini[i].ListR[ptrRiniIndex + k].byteNum))
                                                            ).Trim();
                                                        break;
                                                        
                                                }
                                                //Rtmp.data = sfeadd.Str.TraditionToSimple(dataTradional);
                                               Rtmp.data = dataTradional;
                                                break;
                                            case "2":
                                                Rtmp.dataType = datatypeenum.uint_data;
                                                Rtmp.data = (uint)br.ReadUInt16();
                                                break;
                                            default:
                                                break;

                                        }
                                        Rtmp.dataNum = int.Parse(rini[i].ListR[ptrRiniIndex + k].byteNum);
                                        Rtmp.TypeDef = int.Parse(rini[i].ListR[ptrRiniIndex + k].dataType);
                                        Rtmp.dataName = string.Format(rini[i].ListR[ptrRiniIndex + k].nameStr, j);
                                        Rtmp.descriptionStr = rini[i].ListR[ptrRiniIndex + k].DescriptionStr;
                                        Rdata0.Rbyte.Add(Rtmp);
                                        tmpIndex += int.Parse(rini[i].ListR[ptrRiniIndex + k].byteNum);
                                    }
                                }
                                ptrRiniIndex += int.Parse(rini[i].ListR[ptrRiniIndex].dataStructNum);
                            }
                            Rdata.Rdata0.Add(Rdata0);
                        }
                        RMem.Add(Rdata);
                    }
                }
                filegrp.Close();
                return RMem;
            }
            //catch
            {
                //return null;
            }
        }
    }
}
