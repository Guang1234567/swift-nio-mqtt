//
//  ByteBuffer+PubAckPacket.swift
//  MQTTCodec
//
//  Created by Bofei Zhu on 8/14/19.
//  Copyright © 2019 Bofei Zhu. All rights reserved.
//

import NIO

extension ByteBuffer {

    mutating func readPubAckPacket(with fixedHeader: FixedHeader) throws -> PubAckPacket {
        let packetIdentifier = try readPacketIdentifier()

        let remainingLength = fixedHeader.remainingLength.value
        // If the Remaining Length is 2, then there is no Reason Code and the value of 0x00 (Success) is used.
        var reasonCode: PubAckPacket.ReasonCode = .success

        if remainingLength > 2 {
            reasonCode = try readReasonCode()
        }

        var properties = PropertyCollection()

        // If the Remaining Length is less than 4 there is no Property Length and the value of 0 is used.
        if remainingLength > 3 {
            properties = try readProperties()
        }

        let variableHeader = PubAckPacket.VariableHeader(
            packetIdentifier: packetIdentifier,
            reasonCode: reasonCode,
            properties: properties)

        return PubAckPacket(variableHeader: variableHeader)
    }

    @discardableResult
    mutating func write(_ packet: PubAckPacket) throws -> Int {
        var byteWritten = try write(packet.fixedHeader)

        let variableHeader = packet.variableHeader
        byteWritten += writeInteger(variableHeader.packetIdentifier)

        // The Reason Code and Property Length can be omitted if the Reason Code is 0x00 (Success) and
        // there are no Properties.
        guard !variableHeader.properties.isEmpty || variableHeader.reasonCode != .success else {
            return byteWritten
        }

        byteWritten += writeInteger(variableHeader.reasonCode.rawValue)

        // If the Remaining Length is less than 4 there is no Property Length and the value of 0 is used.
        guard !variableHeader.properties.isEmpty else {
            return byteWritten
        }

        byteWritten += try write(variableHeader.properties)

        return byteWritten
    }
}
