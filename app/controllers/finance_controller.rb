# Finance Controller
class FinanceController < ApplicationController
  def transaction_category
    @transaction_categories ||= FinanceTransactionCategory.all
    authorize! :read, @transaction_categories.last
  end

  def new_transaction_category
    @transaction_category = FinanceTransactionCategory.new
    authorize! :create, @transaction_category
  end

  def create_transaction_category
    @transaction_category = FinanceTransactionCategory.new\
    (transaction_category_params)
    @transaction_category.save
    flash[:notice] = t('transaction_category_create')
    @transaction_categories ||= FinanceTransactionCategory.all
  end

  def edit_transaction_category
    @transaction_category = FinanceTransactionCategory.shod(params[:id])
    authorize! :update, @transaction_category
  end

  def update_transaction_category
    @transaction_category = FinanceTransactionCategory.shod(params[:id])
    @transaction_category.update(transaction_category_params)
    flash[:notice] = t('transaction_category_update')
    @transaction_categories ||= FinanceTransactionCategory.all
  end

  def delete_transaction_category
    @transaction_category = FinanceTransactionCategory.shod(params[:id])
    authorize! :delete, @transaction_category
    @transaction_category.destroy
    flash[:notice] = t('transaction_category_delete')
    redirect_to transaction_category_finance_index_path
  end

  def donation
    @donation = FinanceDonation.new
    authorize! :create, @donation
  end

  def create_donation
    @donation = FinanceDonation.new(donation_params)
    if @donation.save
      @donation.create_transaction
      flash[:notice] = t('donation_create')
      redirect_to donation_receipt_finance_path(@donation)
    else
      render 'donation'
    end
  end

  def donation_receipt
    @donation = FinanceDonation.shod(params[:id])
    authorize! :read, @donation
  end

  def finance_donation_receipt
    @donation = FinanceDonation.shod(params[:id])
    @general_setting = GeneralSetting.first
    render 'finance_donation_receipt', layout: false
  end

  def donors
    @donors ||= FinanceDonation.all
    authorize! :read, @donors.first
  end

  def edit_donation
    @donation = FinanceDonation.shod(params[:id])
    authorize! :update, @donation
  end

  def update_donation
    @donation = FinanceDonation.shod(params[:id])
    if @donation.update(donation_params)
      @donation.update_transaction
      flash[:notice] = t('donation_update')
      redirect_to donors_finance_index_path
    else
      render 'edit_donation'
    end
  end

  def delete_donation
    @donation = FinanceDonation.shod(params[:id])
    authorize! :delete, @donation
    @donation.destroy
    flash[:notice] = t('donation_delete')
    redirect_to donation_finance_index_path
  end

  def new_asset
    @asset = Asset.new
    authorize! :create, @asset
  end

  def create_asset
    @assets ||= Asset.all
    @asset = Asset.new(asset_params)
    @asset.save
    flash[:notice] = t('asset_create')
  end

  def view_asset
    @assets ||= Asset.all
    authorize! :read, @assets.first
  end

  def edit_asset
    @asset = Asset.shod(params[:id])
    authorize! :update, @asset
  end

  def update_asset
    @asset = Asset.shod(params[:id])
    @asset.update(asset_params)
    @assets ||= Asset.all
    flash[:notice] = t('asset_update')
  end

  def delete_asset
    @asset = Asset.shod(params[:id])
    authorize! :delete, @asset
    @asset.destroy
    flash[:notice] = t('asset_delete')
    redirect_to view_asset_finance_index_path
  end

  def asset_list
    @assets ||= Asset.all
    @general_setting = GeneralSetting.first
    render 'asset_list', layout: false
  end

  def each_asset_view
    @asset = Asset.shod(params[:id])
    authorize! :read, @asset
  end

  def new_liability
    @liability = Liability.new
    authorize! :read, @liability
  end

  def create_liability
    @liability = Liability.new(liability_params)
    @liability.save
    flash[:notice] = t('liability_create')
  end

  def view_liability
    @liabilities ||= Liability.all
    authorize! :read, @liabilities.first
  end

  def edit_liability
    @liability = Liability.shod(params[:id])
    authorize! :update, @liability
  end

  def update_liability
    @liabilities ||= Liability.all
    @liability = Liability.shod(params[:id])
    @liability.update(liability_params)
    flash[:notice] = t('liability_update')
  end

  def delete_liability
    @liability = Liability.shod(params[:id])
    authorize! :delete, @liability
    @liability.destroy
    flash[:notice] = t('liability_delete')
    redirect_to view_liability_finance_index_path
  end

  def each_liability_view
    @liability = Liability.shod(params[:id])
    authorize! :read, @liability
  end

  def liability_list
    @liabilities ||= Liability.all
    @general_setting = GeneralSetting.first
    render 'liability_list', layout: false
  end

  def automatic_transaction
    @automatic_transactions ||= FinanceTransactionTrigger.all
    authorize! :read, @automatic_transactions.first
  end

  def new_automatic_transaction
    @automatic_transaction = FinanceTransactionTrigger.new
    @categories ||= FinanceTransactionCategory.all
    authorize! :create, @automatic_transaction
  end

  def create_automatic_transaction
    @automatic_transaction = FinanceTransactionTrigger.new\
    (auto_transaction_params)
    @automatic_transaction.save
    flash[:notice] = t('automatic_transaction_create')
    @automatic_transactions ||= FinanceTransactionTrigger.all
  end

  def edit_automatic_transaction
    @automatic_transaction = FinanceTransactionTrigger.shod(params[:id])
    @categories ||= FinanceTransactionCategory.all
    authorize! :update, @automatic_transaction
  end

  def update_automatic_transaction
    @automatic_transaction = FinanceTransactionTrigger.shod(params[:id])
    @automatic_transaction.update(auto_transaction_params)
    flash[:notice] = t('automatic_transaction_update')
    @automatic_transactions ||= FinanceTransactionTrigger.all
  end

  def delete_automatic_transaction
    @automatic_transaction = FinanceTransactionTrigger.shod(params[:id])
    authorize! :delete, @automatic_transaction
    @automatic_transaction.destroy
    flash[:notice] = t('automatic_transaction_delete')
    redirect_to automatic_transaction_finance_index_path
  end

  def new_expense
    @transaction = FinanceTransaction.new
    @categories ||= FinanceTransactionCategory.expense
    authorize! :create, @transaction
  end

  def create_expense
    @transaction = FinanceTransaction.new(transaction_params)
    if @transaction.save
      flash[:notice] = t('expense_create')
      redirect_to new_expense_finance_index_path
    else
      @categories ||= FinanceTransactionCategory.expense
      render 'new_expense'
    end
  end

  def expense_list
    @start_date = params[:expense][:start_date].to_date
    @end_date = params[:expense][:end_date].to_date
    if @end_date.nil? || @start_date.nil?
      flash[:alert] = t('expense_error')
      render 'view_expense'
    else
      @expenses ||= FinanceTransaction.list(@start_date, @end_date)
    end
    authorize! :read, @expenses.first unless @expenses.nil?
  end

  def edit_expense
    @transaction = FinanceTransaction.shod(params[:id])
    @categories ||= FinanceTransactionCategory.expense
    authorize! :update, @transaction
  end

  def update_expense
    @transaction = FinanceTransaction.shod(params[:id])
    if @transaction.update(transaction_params)
      flash[:notice] = t('expense_update')
      redirect_to view_expense_finance_index_path
    else
      @categories ||= FinanceTransactionCategory.expense
      render 'edit_expense'
    end
  end

  def delete_expense
    @transaction = FinanceTransaction.shod(params[:id])
    authorize! :delete, @transaction
    @transaction.destroy
    flash[:notice] = t('expense_delete')
    redirect_to view_expense_finance_index_path
  end

  def finance_expense_report
    @general_setting = GeneralSetting.first
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    @expenses ||= FinanceTransaction.list(@start_date, @end_date)
    render 'finance_expense_report', layout: false
  end

  def new_income
    @transaction = FinanceTransaction.new
    @categories ||= FinanceTransactionCategory.income
    authorize! :create, @transaction
  end

  def create_income
    @transaction = FinanceTransaction.new(transaction_params)
    if @transaction.save
      flash[:notice] = t('income_create')
      redirect_to new_income_finance_index_path
    else
      @categories ||= FinanceTransactionCategory.income
      render 'new_income'
    end
  end

  def income_list
    @start_date = params[:income][:start_date].to_date
    @end_date = params[:income][:end_date].to_date
    if @start_date.nil? || @end_date.nil?
      flash[:alert] = t('income_error')
      render 'view_income'
    else
      @incomes ||= FinanceTransaction.list(@start_date, @end_date)
    end
    authorize! :read, @incomes.first unless @incomes.nil?
  end

  def edit_income
    @transaction = FinanceTransaction.shod(params[:id])
    @categories ||= FinanceTransactionCategory.income
    authorize! :create, @transaction
  end

  def update_income
    @transaction = FinanceTransaction.shod(params[:id])
    if @transaction.update(transaction_params)
      flash[:notice] = t('income_update')
      redirect_to view_income_finance_index_path
    else
      @categories ||= FinanceTransactionCategory.income
      render 'edit_income'
    end
  end

  def delete_income
    @transaction = FinanceTransaction.shod(params[:id])
    authorize! :delete, @transaction
    @transaction.destroy
    flash[:notice] = t('income_delete')
    redirect_to view_income_finance_index_path
  end

  def finance_income_report
    @general_setting = GeneralSetting.first
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    @incomes ||= FinanceTransaction.list(@start_date, @end_date)
    render 'finance_income_report', layout: false
  end

  def transactions_list
    @start_date = params[:transaction][:start_date].to_date
    @end_date = params[:transaction][:end_date].to_date
    if @start_date.nil? || @end_date.nil?
      flash[:alert] = t('transaction_error')
      render 'transaction_report'
    else
      @categories ||= FinanceTransactionCategory.all
    end
    authorize! :read, @categories.first unless @categories.nil?
  end

  def expense_details
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    @category = FinanceTransactionCategory.shod(params[:category])
    @expenses ||= @category.finance_transactions.list(@start_date, @end_date)
    render 'expense_list'
    authorize! :read, @category
  end

  def income_details
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    @category = FinanceTransactionCategory.shod(params[:category])
    @incomes ||= @category.finance_transactions.list(@start_date, @end_date)
    render 'income_list'
    authorize! :read, @category
  end

  def finance_transaction_report
    @general_setting = GeneralSetting.first
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    @categories ||= FinanceTransactionCategory.all
    render 'finance_transaction_report', layout: false
  end

  def transactions_comparison
    @start_date1 = params[:transaction][:start_date1].to_date
    @end_date1 = params[:transaction][:end_date1].to_date
    @start_date2 = params[:transaction][:start_date2].to_date
    @end_date2 = params[:transaction][:end_date2].to_date
    if @start_date1.nil? || @start_date2.nil? \
      || @end_date1.nil? || @end_date2.nil?
      render 'compare_report', alert: t('transaction_error')
    else
      @categories ||= FinanceTransactionCategory.all
    end
  end

  def new_master_category
    @master_category = FinanceFeeCategory.new
    @batches ||= Batch.all
    authorize! :create, @master_category
  end

  def assign_batch
    @batches ||= Batch.all
  end

  def remove_batch
    @batches ||= Batch.all
  end

  def create_master_category
    @master_category = FinanceFeeCategory.new(fee_category_params)
    @master_category.save
    @master_category.fee_category(params[:batches])
    flash[:notice] = t('fee_category_create')
  end

  def fees_list
    @batch = Batch.shod(params[:batch][:id])
    @master_categories ||= @batch.finance_fee_categories
    authorize! :read, @master_categories.first
  end

  def edit_master_category
    @batch = Batch.shod(params[:id])
    @master_category = FinanceFeeCategory.shod(params[:id])
    authorize! :update, @master_category
  end

  def update_master_category
    @batch = Batch.shod(params[:id])
    @master_category = @batch.finance_fee_categories.shod(params[:id])
    @master_category.update(fee_category_params)
    flash[:notice] = t('fee_category_update')
    @master_categories ||= @batch.finance_fee_categories
  end

  def delete_master_category
    @batch = Batch.shod(params[:batch_id])
    @master_category = @batch.finance_fee_categories.shod(params[:id])
    authorize! :delete, @master_category
    @master_category.destroy
    flash[:notice] = t('fee_category_delete')
    @master_categories ||= @batch.finance_fee_categories
  end

  def new_fees_particular
    @fee = FinanceFeeParticular.new
    @categories ||= FinanceFeeCategory.all
    authorize! :create, @fee
  end

  def category_batch
    @master_category = FinanceFeeCategory.shod(params[:id])
    @batches ||= @master_category.batches
    authorize! :read, @master_category
  end

  def create_fees_particular
    @categories ||= FinanceFeeCategory.all
    @fee = FinanceFeeParticular.new(fee_particular_params)
    result = FinanceFeeParticular.create_fee(fee_particular_params\
      , params[:batches], params[:mode]\
      , params[:admission_no], params[:category])
    if result == 1
      render 'new_fees_particular'
    else
      flash[:notice] = t('fee_create')
      redirect_to master_fees_finance_index_path
    end
  end

  def master_category_particular
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:id])
    @particular_fees ||= @master_category.particulars(@batch.id)
    authorize! :read, @master_category
  end

  def master_fees
    @batches ||= Batch.includes(:course).all
  end

  def new_particular_fee
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:id])
    @fee = FinanceFeeParticular.new
    authorize! :create, @fee
  end

  def student_admission_no
    @master_category = FinanceFeeCategory.shod(params[:id])
    @fee = FinanceFeeParticular.new
    authorize! :read, @fee
  end

  def student_category
    @master_category = FinanceFeeCategory.shod(params[:id])
    @fee = FinanceFeeParticular.new
    authorize! :read, @fee
  end

  def create_particular_fee
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:id])
    @particular_fees ||= @master_category.particulars(@batch.id)
    @fee = @master_category.finance_fee_particulars.new(fee_particular_params)
    @fee.set(params[:mode], params[:admission_no]\
      , params[:category], @batch.id)
    @fee.save
    flash[:notice] = t('fee_create')
  end

  def edit_particular_fee
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:master_id])
    @fee = @master_category.finance_fee_particulars.shod(params[:id])
    authorize! :update, @fee
  end

  def update_particular_fee
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:master_id])
    @particular_fees ||= @master_category.particulars(@batch.id)
    @fee = @master_category.finance_fee_particulars.shod(params[:id])
    @fee.update(fee_particular_params)
    flash[:notice] = t('fee_update')
  end

  def delete_particular_fee
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:id])
    @fee = @master_category.finance_fee_particulars.shod(params[:fee])
    authorize! :delete, @fee
    @particular_fees ||= @master_category.particulars(@batch.id)
    @fee.destroy
    flash[:notice] = t('fee_delete')
  end

  def new_fee_discount
    @fee_discount = FeeDiscount.new
    @categories ||= FinanceFeeCategory.all
    authorize! :create, @discount
  end

  def discount_type
    @type = params[:type]
  end

  def create_fee_discount
    @categories ||= FinanceFeeCategory.all
    @discount = FeeDiscount.new(fee_discount_params)
    result = FeeDiscount.create_discount(fee_discount_params\
      , params[:batches], params[:admission_no], params[:category])
    if result == 1
      render 'new_fee_discount'
    else
      flash[:notice] = t('discount_create')
      redirect_to new_fee_discount_finance_index_path
    end
  end

  def fee_category
    @batch = Batch.shod(params[:id])
    @categories ||= @batch.finance_fee_categories
    authorize! :read, @categories.first
  end

  def discount_view
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:id])
    @discounts ||= @master_category.discounts(@batch.id)
    authorize! :read, @discounts.first
  end

  def edit_fee_discount
    @batch = Batch.shod(params[:id])
    @master_category = FinanceFeeCategory.shod(params[:master_id])
    @discount = @master_category.fee_discounts.shod(params[:discount_id])
    authorize! :update, @discount
  end

  def update_fee_discount
    @batch = Batch.shod(params[:batch_id])
    @master_category = FinanceFeeCategory.shod(params[:master_id])
    @discount = @master_category.fee_discounts.shod(params[:id])
    @discount.update(fee_discount_params)
    flash[:notice] = t('discount_update')
    @discounts ||= @master_category.discounts(@batch.id)
  end

  def delete_fee_discount
    @batch = Batch.shod(params[:id])
    @master_category = FinanceFeeCategory.shod(params[:master_id])
    @discount = @master_category.fee_discounts.shod(params[:discount_id])
    authorize! :delete, @discount
    @discount.destroy
    flash[:notice] = t('discount_delete')
    @discounts ||= @master_category.discounts(@batch.id)
  end

  def new_fee_collection
    @collection = FinanceFeeCollection.new
    @categories ||= FinanceFeeCategory.all
    authorize! :create, @collection
  end

  def create_fee_collection
    @collection = FinanceFeeCollection.new(collection_params)
    result = FinanceFeeCollection.fee(collection_params, params[:batches])
    if result == true
      @categories ||= FinanceFeeCategory.all
      render 'new_fee_collection'
    else
      flash[:notice] = t('collection_create')
      redirect_to new_fee_collection_finance_index_path
    end
  end

  def view_fee_collection
    @batch = Batch.shod(params[:id])
    @collections ||= @batch.finance_fee_collections
    authorize! :read, @collections.first
  end

  def edit_fee_collection
    @batch = Batch.shod(params[:id])
    @collections ||= @batch.finance_fee_collections
    @collection = @batch.finance_fee_collections.shod(params[:collection_id])
    authorize! :update, @collection
  end

  def update_fee_collection
    @batch = Batch.shod(params[:batch_id])
    @collections ||= @batch.finance_fee_collections
    @collection = @batch.finance_fee_collections.shod(params[:id])
    @collection.update(collection_params)
    flash[:notice] = t('collection_update')
  end

  def delete_fee_collection
    @batch = Batch.shod(params[:id])
    @collection = @batch.finance_fee_collections.shod(params[:collection_id])
    authorize! :delete, @collection
    @collections ||= @batch.finance_fee_collections
    @collection.destroy
    flash[:notice] = t('collection_delete')
  end

  def collection_details_view
    @collection = FinanceFeeCollection.shod(params[:id])
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    authorize! :read, @collection
  end

  def fees_submission_batch
    @batches ||= Batch.includes(:course).all
    @collections ||= Batch.first.finance_fee_collections unless Batch.first.nil?
    authorize! :read, @collections.first unless @collections.nil?
  end

  def fee_collection_date
    @batch = Batch.shod(params[:id])
    @collections ||= @batch.finance_fee_collections
    authorize! :read, @collections.first
  end

  def student_fees
    @collection = FinanceFeeCollection.shod(params[:id])
    @category = @collection.finance_fee_category
    @finance_fees ||= @collection.finance_fees
    @student = @finance_fees.first.student
    @previous = @collection.previous(@student)
    @next = @collection.next(@student)
    @fee = @collection.fee(@student)
    student_fee2
    authorize! :read, @collection
  end

  def student_fee2
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    @transactions ||= @fee.finance_transactions
    @fines ||= @fee.finance_fines
  end

  def student_fees_details
    @collection = FinanceFeeCollection.shod(params[:id])
    @category = @collection.finance_fee_category
    @finance_fees ||= @collection.finance_fees
    @finance_fee = @finance_fees.shod(params[:finance_fee_id])
    @student = @finance_fee.student
    @previous = @collection.previous(@student)
    student_fees_details2
    authorize! :read, @collection
  end

  def student_fees_details2
    @next = @collection.next(@student)
    @fee = @collection.fee(@student)
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    @transactions ||= @fee.finance_transactions
    @fines ||= @fee.finance_fines
  end

  def pay_fine
    @student_fine = FinanceFee.shod(params[:finance_fee_id])
    @student_fine.create_fine(params[:fine])
    @collection = FinanceFeeCollection.shod(params[:id])
    @category = @collection.finance_fee_category
    @finance_fees ||= @collection.finance_fees
    @finance_fee = @finance_fees.shod(params[:finance_fee_id])
    @student = @finance_fee.student
    pay_fine2
    authorize! :read, @collection
  end

  def pay_fine2
    @previous = @collection.previous(@student)
    @next = @collection.next(@student)
    @fee = @collection.fee(@student)
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    @transactions ||= @fee.finance_transactions
    @fines ||= @fee.finance_fines
  end

  def pay_fee
    @student_fee = FinanceFee.shod(params[:finance_fee_id])
    @student_fee.create_transaction(params[:amount], false)
    @student_fee.update(is_paid: true) if params[:amount] \
    == params[:pay_amount]
    @collection = FinanceFeeCollection.shod(params[:id])
    @category = @collection.finance_fee_category
    @finance_fees ||= @collection.finance_fees
    @finance_fee = @finance_fees.shod(params[:finance_fee_id])
    pay_fee2
    authorize! :read, @collection
  end

  def pay_fee2
    @student = @finance_fee.student
    @previous = @collection.previous(@student)
    @next = @collection.next(@student)
    @fee = @collection.fee(@student)
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    @transactions ||= @fee.finance_transactions
    @fines ||= @fee.finance_fines
  end

  def student_fee_receipt
    @general_setting = GeneralSetting.first
    @collection = FinanceFeeCollection.shod(params[:id])
    @category = @collection.finance_fee_category
    @finance_fees ||= @collection.finance_fees
    @finance_fee = @finance_fees.shod(params[:finance_fee_id])
    student_fee_receipt2
    render 'student_fee_receipt', layout: false
  end

  def student_fee_receipt2
    @student = @finance_fee.student
    @fee = @collection.fee(@student)
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    @fines ||= @fee.finance_fines
  end

  def search_student
    @students = Student.search(params[:search], 'present')
  end

  def fees_collection_student
    @student = Student.shod(params[:id])
    @collections ||= @student.finance_fee_collections
    authorize! :read, @collections.first
  end

  def student_fees_submission
    @student = Student.shod(params[:student_id])
    @collection = FinanceFeeCollection.shod(params[:collection_id])
    @category = @collection.finance_fee_category
    @finance_fees ||= @collection.finance_fees
    @fee = @collection.fee(@student)
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    @transactions ||= @fee.finance_transactions
    @fines ||= @fee.finance_fines
    authorize! :read, @collection
  end

  def student_search
    @students = Student.search(params[:search], 'present')
  end

  def fee_collection_structure
    @student = Student.shod(params[:id])
    @collections ||= @student.finance_fee_collections
    authorize! :read, @collections.first
  end

  def student_fees_structure
    @student = Student.shod(params[:student_id])
    @collection = FinanceFeeCollection.shod(params[:collection_id])
    @category = @collection.finance_fee_category
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    authorize! :read, @collection
  end

  def fee_structure
    @general_setting = GeneralSetting.first
    @student = Student.shod(params[:student_id])
    @collection = FinanceFeeCollection.shod(params[:collection_id])
    @category = @collection.finance_fee_category
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    render 'fee_structure', layout: false
  end

  def fees_defaulters
    @courses ||= Course.all
    @batches ||= Course.first.batches unless Course.first.nil?
    @collections ||= Batch.first.finance_fee_collections unless Batch.first.nil?
    authorize! :read, @collections.first unless @collections.nil?
  end

  def batch_choice
    @course = Course.shod(params[:id])
    @batches ||= @course.batches
  end

  def collection_choice
    @batch = Batch.shod(params[:id])
    @collections ||= @batch.finance_fee_collections
    authorize! :read, @collections.first
  end

  def defaulter_students
    @collection = FinanceFeeCollection.shod(params[:id])
    @students ||= @collection.students
    authorize! :read, @collection
  end

  def fees_defaulters_list
    @general_setting = GeneralSetting.first
    @collection = FinanceFeeCollection.shod(params[:id])
    @students ||= @collection.students
    render 'fees_defaulters_list', layout: false
  end

  def pay_fees_defaulters
    @student = Student.shod(params[:student_id])
    @collection = FinanceFeeCollection.shod(params[:collection_id])
    @category = @collection.finance_fee_category
    @finance_fees ||= @collection.finance_fees
    @fee = @collection.fee(@student)
    @particulars ||= @collection.fee_collection_particulars
    @discounts ||= @collection.fee_collection_discounts
    @transactions ||= @fee.finance_transactions
    @fines ||= @fee.finance_fines
    authorize! :read, @collection
  end

  def approve_monthly_payslip
    @salary_months ||= MonthlyPayslip.select(:salary_date).distinct
  end

  def approve_salary
    @salary_months ||= MonthlyPayslip.where(salary_date: params[:date])
    @salary = @salary_months.first
    @date = params[:date]
  end

  def approve
    @salary_months ||= MonthlyPayslip.where(salary_date: params[:date])
    @salary_months.each(&:approve_salary)
    flash[:notice] = t('payslip_approve')
    redirect_to approve_monthly_payslip_finance_index_path
  end

  def view_monthly_payslip
    @departments ||= EmployeeDepartment.all
    @salary_months ||= MonthlyPayslip.select(:salary_date).distinct
  end

  def view_payslip
    @payslips = []
    @department = EmployeeDepartment.shod(params[:payslip][:department])
    @date = params[:payslip][:date]
    @employees ||= @department.employees
    return if @employees.nil?
    @employees.each do |e|
      salary = e.salary(@date)
      @payslips << salary unless salary.nil?
    end
  end

  def employee_monthly_payslip
    @general_setting = GeneralSetting.first
    @payslips = params[:payslips]
    render 'employee_monthly_payslip', layout: false
  end

  def view_employee_payslip
    @employee = Employee.shod(params[:id])
    @date = params[:date]
    @structures ||= @employee.employee_salery_structures
    @salary = @employee.salary(@date)
    @individual_salary = @employee.personal_salary(@date)
  end

  def employee_payslip
    @general_setting = GeneralSetting.first
    @employee = Employee.shod(params[:id])
    @date = params[:date]
    @structures ||= @employee.employee_salery_structures
    @salary = @employee.salary(@date)
    @individual_salary = @employee.personal_salary(@date)
    render 'employee_payslip', layout: false
  end

  def fee_discounts
    @batches ||= Batch.includes(:course).all
  end

  def fee_collection_view
    @batches ||= Batch.includes(:course).all
  end

  private

  def transaction_category_params
    params.require(:finance_transaction_category).permit!
  end

  def donation_params
    params.require(:finance_donation).permit!
  end

  def asset_params
    params.require(:asset).permit!
  end

  def liability_params
    params.require(:liability).permit!
  end

  def auto_transaction_params
    params.require(:finance_transaction_trigger).permit!
  end

  def transaction_params
    params.require(:finance_transaction).permit!
  end

  def fee_category_params
    params.require(:finance_fee_category).permit!
  end

  def fee_particular_params
    params.require(:finance_fee_particular).permit!
  end

  def fee_discount_params
    params.require(:fee_discount).permit!
  end

  def collection_params
    params.require(:finance_fee_collection).permit!
  end
end
