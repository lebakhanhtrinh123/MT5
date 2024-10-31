//+------------------------------------------------------------------+
//|                                                         test.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
CTrade trade;
int OnInit()

  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
input double LotSize = 0.01 ;
input int  StopLoss_Point =1000;
input int TaskProfit_Point = 1000;
double Ask,Bid;
void OnTick() {
    Ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
    Bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);

    // Kiểm tra 3 nến liên tiếp
    if (CountOrder("OP_SELL") == 0 &&
        CheckColorCandle(Symbol(), Period(), 1) == "RED" &&
        CheckColorCandle(Symbol(), Period(), 2) == "RED" &&
        CheckColorCandle(Symbol(), Period(), 3) == "RED") {
        trade.Sell(LotSize, Symbol(), Bid, Bid + StopLoss_Point * Point(), Bid - TaskProfit_Point * Point(), "Trinh");
    }

    if (CountOrder("OP_BUY") == 0 &&
        CheckColorCandle(Symbol(), Period(), 1) == "BLUE" &&
        CheckColorCandle(Symbol(), Period(), 2) == "BLUE" &&
        CheckColorCandle(Symbol(), Period(), 3) == "BLUE") {
        trade.Buy(LotSize, Symbol(), Ask, Ask - StopLoss_Point * Point(), Ask + TaskProfit_Point * Point(), "Trinh");
    }
}
//+------------------------------------------------------------------+
string CheckColorCandle(string symbol, ENUM_TIMEFRAMES tf_candle, int shift)
{
    string ColorCandle = "";
    if (iOpen(symbol, tf_candle, shift) <= iClose(symbol, tf_candle, shift))
    {
        ColorCandle = "BLUE";  // Nến tăng
    }
    else
    {
        ColorCandle = "RED";   // Nến giảm
    }
    return ColorCandle;
}
int CountOrder(string type){
   int count = 0 ; 
   for(int i = PositionsTotal() - 1 ; i>=0 ;  i--)
   {
      ENUM_POSITION_TYPE PositionType = ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE));
      ulong PositionTicket =  PositionGetTicket(i);
     
         string _symbol = PositionGetString(POSITION_SYMBOL);
         if(_symbol == _Symbol)
         {
            if(type == "All"){
            count ++;
            }
            if(type=="AllLimitStop"  && PositionType>1){
            count++;
            }
            if(type=="OP_BUY"  && PositionType == 0){
            count++;
            }
            if(type=="OP_SELL"  && PositionType==1){
            count++;
            }
             if(type=="OP_BUYLIMIT"  && PositionType == 2){
            count++;
            }
            if(type=="OP_SELLLIMIT"  && PositionType == 3){
            count++;
            }
            if(type=="OP_BUYSTOP"  && PositionType == 4){
            count++;
            }
            if(type=="OP_SELLSTOP"  && PositionType == 5){
            count++;
            }
            if(type=="OP_SELL_OP_BUY"  && PositionType > -1 && PositionType <2){
            count++;     
            }
         }  
         if (type == "AllAllAll") {
        count++;
        }
    }
   return count;
   
}

