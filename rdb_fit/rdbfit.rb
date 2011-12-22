require "dbi"

module RdbFit
  class Rdbfit
    # Usage:
    #  initialize(host, username, password, db, querystr, dbtype)
    #   (dbtype is optional if a Mysql or PostgreSQL default host port is given in host.)
    # or
    #  initialize(connection_string, querystr)
    def initialize(host, username, password='', db='', querystr='', dbtype='')
      if username != '' && password == '' && db == '' && querystr == '' && dbtype == ''
        querystr = username
        username = ''
      end
      if dbtype == '' && username != '' && password != '' && db != '' && querystr != ''
        # Attempt to guess the database by port number.
        dbtype = 'Mysql' if /:3306$/ === host
        dbtype = 'PostgreSQL' if /:5432$/ === host
        raise "Can't identify the database!" if dbtype == ''
      end

      @connection = nil
      ObjectSpace.define_finalizer(self, proc {
        @connection.rollback if @connection
        @connection.disconnect if @connection
      })

      if username != '' && password != '' && db != '' && querystr != '' && dbtype != ''
        @connection = DBI.connect("DBI:#{dbtype}:#{db}:#{host}", username, password)
      else
        # Trust that the user provided a valid connection string.
        @connection = DBI.connect("DBI:#{host}")
      end
        
      @sth = @connection.execute(querystr)
      # These vars are for method_missing.
      @is_decision_table = false
      # The vertical position of each column header we're testing.
      @header_count = {}
      # The vertical position of the row we've read.
      @current_row_count = -1
      # The the row we've read, as a hash.
      @current_row = nil
    end

    # The standard QueryTable method.
    def query
      retval = []
      @sth.fetch_hash do |row|
        rowval = []
        row.each{|key,value| rowval.push([key, value])}
        retval.push(rowval)
      end
      @sth.finish
      return retval
    end

    # DecisionTable as QueryTable methods

    # Invoke a missing method. If a method is called via a DecisionTable,
    # this method will try to treat that method name as the header of a column.
    def method_missing(method, *args, &block)
      # Ensure we have a DB row.
      if @current_row_count < 0 
        @current_row = @sth.fetch_hash
        @current_row_count += 1
      end 

      return "Row not found!" if @current_row == nil

      # Ensure this method maps to a DB column to be read.
      # (No inputs are allowed in this pseudo-query table.)
      # Otherwise ignore this method name.
      method = method.to_s.sub(/^column_/,'')
      return super if args.length > 0 || !@current_row.has_key?(method)

      # Set the header_count for this header to the current row,
      # based on reads of this header.
      if @header_count[method] == nil
        @header_count[method] = 0 
      else
        @header_count[method] += 1
      end

      # Ensure we get a new DB row if we need one.
      if @header_count[method] > @current_row_count
        @current_row = @sth.fetch_hash
        @current_row_count += 1
        raise "Skipped a row on #{method}" if @header_count[method] > @current_row_count
      end 

      # Finally, return the expected value.
      return @current_row[method]
    end

    def respond_to?(method)
      # If there's already a method here that responds, use it.
      return true if super
      method = method.to_s.sub(/^column_/,'')
      # Methods that don't exist but don't mean we're in a DecisionTable.
      return false if /^(table|sut)$/ === method
      # Ensure we have a DB row.
      if @current_row_count < 0 
        @current_row = @sth.fetch_hash
        @current_row_count += 1
      end 

      # Ensure this method maps to a DB column to be read.
      # Otherwise ignore this method name.
      return @current_row == nil || @current_row.has_key?(method)
    end
  end
end
