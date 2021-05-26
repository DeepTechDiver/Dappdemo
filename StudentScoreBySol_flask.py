#!/usr/bin/env python
# -*- coding: utf-8 -*-
from StudentScoreBySol_contract import Contract
import json
from flask import Flask, jsonify, request
import requests
from evidence_contract import Evidence_Contract
from flask_cors import CORS


app = Flask(__name__)
tx_client = transaction_common.TransactionCommon("","contracts","StudentScoreBySol")

@app.route('/')
def index():







if __name__ ==  '__main__' :
    app.run(host="0.0.0.0", port=80)