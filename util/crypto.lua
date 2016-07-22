---------------------------
-- 加解密、数据编码的全局模块
--
-- @module crypto
local crypto = class("crypto")


---------------------------
-- 使用 AES256 算法加密内容
-- 提示：AES256 仅在 iOS 和 Mac 平台可用。加解密尽量选择跨平台的 XXTEA 接口。
--
--@function [parent=#crypto] encryptAES256
--@param string#string plaintext 明文字符串
--@param string#string key 密钥字符串
--@return string#string 加密后的字符串
function crypto.encryptAES256(plaintext, key)
    plaintext = tostring(plaintext)
    key = tostring(key)
    return cc.Crypto:encryptAES256(plaintext, string.len(plaintext), key, string.len(key))
end


---------------------------
--使用 AES256 算法解密内容
--提示： AES256 仅在 iOS 和 Mac 平台可用。加解密尽量选择跨平台的 XXTEA 接口。
--
--@function [parent=#crypto] decryptAES256
--@param string#string ciphertext 加密后的字符串
--@param string#string key 密钥字符串
--@return string#string 明文字符串
function crypto.decryptAES256(ciphertext, key)
    ciphertext = tostring(ciphertext)
    key = tostring(key)
    return cc.Crypto:decryptAES256(ciphertext, string.len(ciphertext), key, string.len(key))
end


---------------------------
--使用 XXTEA 算法加密内容
--@function [parent=#crypto] encryptXXTEA
--@param string#string plaintext 明文字符串
--@param string#string key 密钥字符串
--@return string#string 加密后的字符串
function crypto.encryptXXTEA(plaintext, key)
    plaintext = tostring(plaintext)
    key = tostring(key)
    return cc.Crypto:encryptXXTEA(plaintext, string.len(plaintext), key, string.len(key))
end


---------------------------
--使用 XXTEA 算法解密内容
--
--@function [parent=#crypto] decryptXXTEA
--@param string#string ciphertext 加密后的字符串
--@param string#string key 密钥字符串
--@return string#string 明文字符串
function crypto.decryptXXTEA(ciphertext, key)
    ciphertext = tostring(ciphertext)
    key = tostring(key)
    return cc.Crypto:decryptXXTEA(ciphertext, string.len(ciphertext), key, string.len(key))
end


---------------------------
--使用 BASE64 算法编码内容
--@function [parent=#crypto] encodeBase64
--@param string#string plaintext 原文字符串
--@return string#string 编码后的字符串
function crypto.encodeBase64(plaintext)
    plaintext = tostring(plaintext)
    return cc.Crypto:encodeBase64(plaintext, string.len(plaintext))
end


---------------------------
--使用 BASE64 算法解码内容
--
--@function [parent=#crypto] decodeBase64
--@param string#string ciphertext 编码后的字符串
--@return string#string 原文字符串
function crypto.decodeBase64(ciphertext)
    ciphertext = tostring(ciphertext)
    return cc.Crypto:decodeBase64(ciphertext)
end


---------------------------
--计算内容的 MD5 码
--@function [parent=#crypto] md5
--@param string#string plaintext 原文字符串
--@param boolean#boolean isRawOutput 是否返回二进制 MD5 码
--@return string#string 编码后的字符串
function crypto.md5(input, isRawOutput)
    input = tostring(input)
    if type(isRawOutput) ~= "boolean" then isRawOutput = false end
    return cc.Crypto:MD5(input, isRawOutput)
end


---------------------------
--计算文件的 MD5 码
--@function [parent=#crypto] md5file
--@param string#string path 文件路径
--@return string#string MD5 字符串
function crypto.md5file(path)
    if not path then
        printError("crypto.md5file() - invalid filename")
        return nil
    end
    path = tostring(path)
    if DEBUG > 1 then
        printInfo("crypto.md5file() - filename: %s", path)
    end
    return cc.Crypto:MD5File(path)
end



---------------------------
--混淆内存数字
--@function [parent=#crypto] confuse
--@param number#number intValue 
--@return number#number 
function crypto.confuse(intValue)
    local bit = require("bit")
    return bit.bxor(intValue, DNP_APP.confuseKey) + DNP_APP.confuseKey
end


---------------------------
--混淆内存数字增加值
--@function [parent=#crypto] confuse
--@param number#number confuseValue 
--@param number#number plusValue 
--@return number#number 
function crypto.confusePlus(confuseValue, plusValue)
    local bit = require("bit")
    local tmp = bit.bxor(confuseValue - DNP_APP.confuseKey , DNP_APP.confuseKey)
    return bit.bxor(tmp + plusValue, DNP_APP.confuseKey) + DNP_APP.confuseKey
end


---------------------------
--反混淆内存数字
--@function [parent=#crypto] confuse
--@param number#number intValue 
--@return number#number 
function crypto.deConfuse(intValue)
    local bit = require("bit")
    return bit.bxor(intValue - DNP_APP.confuseKey , DNP_APP.confuseKey)
end



return crypto
