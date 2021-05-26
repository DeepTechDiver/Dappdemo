#!/usr/bin/env python
# -*- coding: utf-8 -*-

from client.bcosclient import BcosClient
from client.datatype_parser import DatatypeParser

class Contract:
    def __init__(self, address: str):
        """
        :param address: 合约地址
        :return:
        """

        # 合约地址
        self.to_address = address

        # 读取abi文件，并转为json格式
        abi_file = "contracts/HelloWorld.abi"
        data_parser = DatatypeParser()
        data_parser.load_abi_file(abi_file)
        self.contract_abi = data_parser.contract_abi

        # 创建BcosClient实例
        self.client = BcosClient()

    def sendtx(self, fn_name, args=None):
        """
        :param fn_name: 对应合约中的函数名
        :param args: fn_name的参数
        :return: 交易信息，json格式
        """
        if args is None:
            sendtx_result = self.client.sendRawTransactionGetReceipt(self.to_address, self.contract_abi, fn_name, [])
        else:
            sendtx_result = self.client.sendRawTransactionGetReceipt(self.to_address, self.contract_abi, fn_name, [args])
        return {"result": sendtx_result}

    def call(self, fn_name, args=None):
        """
        :param fn_name: 对应合约中的函数名
        :param args: fn_name的参数
        :return: 交易信息，json格式
        """

        if args is None:
            call_result = self.client.call(self.to_address, self.contract_abi, fn_name, [])
        else:
            call_result = self.client.call(self.to_address, self.contract_abi, fn_name, [args])
        return {"result": call_result}


contract_address = "0x83592a3cf1af302612756b8687c8dc7935c0ad1d"
cnt = Contract(contract_address)
call_msg = cnt.call("get")
print(call_msg)

send_msg = cnt.sendtx("set", "hello, fengfeng")
print(send_msg)

call_finish = cnt.call("get")
print(call_finish)

