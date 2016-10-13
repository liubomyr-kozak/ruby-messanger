module ApplicationHelpers
  def destroyRecords(recordItem)
    if recordItem.whenDelete == 'deleteInHour'

      messageTimeStamp = recordItem.timeStamp.to_i
      currentTimeStamp = DateTime.now.to_time.to_i
      timeStampDiffer = currentTimeStamp - messageTimeStamp

      timeDiffer = (timeStampDiffer / 60 / 60).floor >= 1

      if timeDiffer
        recordItem.destroy
        return nil
      end
    end

    return recordItem
  end
end