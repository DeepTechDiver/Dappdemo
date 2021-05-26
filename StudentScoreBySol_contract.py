#!/usr/bin/env python
# -*- coding: utf-8 -*-
from client.bcosclient import BcosClient
from client.datatype_parser import DatatypeParser

class Contract:
    def __init__(self, address: str):
        # 合约地址
        self.to_address = address
        # 读取abi文件，并转为json格式
        abi_file = "contracts/StudentScoreBySol.abi"
        data_parser = DatatypeParser()
        data_parser.load_abi_file(abi_file)
        self.contract_abi = data_parser.contract_abi

        # 创建BcosClient实例
        self.client = BcosClient()
